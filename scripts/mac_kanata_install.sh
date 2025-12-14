#!/usr/bin/env bash
set -euo pipefail

# mac_kanata_install.sh
# Installs:
# - kanata (Homebrew)
# - Karabiner-DriverKit-VirtualHIDDevice (pkg)
# Configures:
# - launchd (LaunchDaemons) for:
#   - Karabiner-VirtualHIDDevice-Manager activate
#   - Karabiner-VirtualHIDDevice-Daemon
#   - kanata (runs as root)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./utils_logging.sh
source "$SCRIPT_DIR/utils_logging.sh"

if [[ "${OSTYPE:-}" != darwin* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

# ---- Configuration (override via env vars) ----
LAUNCHD_LABEL_PREFIX=${LAUNCHD_LABEL_PREFIX:-com.pszponder.kanata}
PLIST_DIR=${PLIST_DIR:-/Library/LaunchDaemons}
LOG_DIR=${LOG_DIR:-/Library/Logs/Kanata}

KANATA_CFG=${KANATA_CFG:-"$HOME/.config/kanata/config.kbd"}
KANATA_PORT=${KANATA_PORT:-}
KANATA_EXTRA_ARGS=${KANATA_EXTRA_ARGS:-}

# If set, use this URL directly instead of GitHub API lookup.
DRIVERKIT_PKG_URL=${DRIVERKIT_PKG_URL:-}
# Optional GitHub release tag, e.g. v6.2.0
DRIVERKIT_VERSION_PIN=${DRIVERKIT_VERSION_PIN:-}
# Optional token to avoid GitHub API rate limits
GITHUB_TOKEN=${GITHUB_TOKEN:-}

# Paths installed by the official pkg
VHID_MANAGER_BIN=${VHID_MANAGER_BIN:-/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager}
VHID_DAEMON_BIN=${VHID_DAEMON_BIN:-"/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Karabiner-VirtualHIDDevice-Daemon"}

LABEL_VHID_MANAGER="${LAUNCHD_LABEL_PREFIX}.karabiner-vhidmanager"
LABEL_VHID_DAEMON="${LAUNCHD_LABEL_PREFIX}.karabiner-vhiddaemon"
LABEL_KANATA="${LAUNCHD_LABEL_PREFIX}.daemon"

PLIST_VHID_MANAGER="${PLIST_DIR}/${LABEL_VHID_MANAGER}.plist"
PLIST_VHID_DAEMON="${PLIST_DIR}/${LABEL_VHID_DAEMON}.plist"
PLIST_KANATA="${PLIST_DIR}/${LABEL_KANATA}.plist"

require_cmd() {
    local cmd="$1"
    local install_hint="${2:-}"

    if ! command -v "$cmd" >/dev/null 2>&1; then
        log_error "Missing required command: $cmd"
        if [[ -n "$install_hint" ]]; then
            log_info "Install it with: $install_hint"
        fi
        exit 1
    fi
}

expand_path() {
    # Expands leading ~ and $HOME etc.
    local p="$1"
    # shellcheck disable=SC2086
    eval "echo $p"
}

mktemp_file() {
    mktemp "${TMPDIR:-/tmp}/kanata.XXXXXX"
}

launchd_bootstrap_enable_kickstart() {
    local plist_path="$1"
    local label="$2"

    # Bootout might fail if not loaded; ignore.
    sudo launchctl bootout system "$plist_path" >/dev/null 2>&1 || true
    sudo launchctl bootstrap system "$plist_path"
    sudo launchctl enable "system/${label}" >/dev/null 2>&1 || true
    sudo launchctl kickstart -k "system/${label}" >/dev/null 2>&1 || true
}

write_plist() {
    local dst="$1"
    local content="$2"

    local tmp
    tmp="$(mktemp_file)"
    printf "%s" "$content" >"$tmp"

    sudo mkdir -p "$(dirname "$dst")"
    sudo install -m 0644 "$tmp" "$dst"
    sudo chown root:wheel "$dst" 2>/dev/null || true

    rm -f "$tmp"
}

get_driverkit_pkg_url_from_github() {
    require_cmd jq "brew install jq"

    local api_url
    if [[ -n "$DRIVERKIT_VERSION_PIN" ]]; then
        api_url="https://api.github.com/repos/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tags/${DRIVERKIT_VERSION_PIN}"
    else
        api_url="https://api.github.com/repos/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/latest"
    fi

    local headers=()
    headers+=("-H" "Accept: application/vnd.github+json")
    if [[ -n "$GITHUB_TOKEN" ]]; then
        headers+=("-H" "Authorization: Bearer ${GITHUB_TOKEN}")
    fi

    # shellcheck disable=SC2068
    curl -fsSL ${headers[@]} "$api_url" \
        | jq -r '.assets[] | select(.name | endswith(".pkg")) | .browser_download_url' \
        | head -n 1
}

install_kanata() {
    require_cmd brew

    if command -v kanata >/dev/null 2>&1; then
        log_success "kanata already installed: $(command -v kanata)"
        return 0
    fi

    log_info "Installing kanata via Homebrew..."
    brew install kanata

    if ! command -v kanata >/dev/null 2>&1; then
        log_error "kanata install completed but 'kanata' is still not on PATH."
        log_info "Try starting a new shell, or ensure Homebrew is in PATH."
        exit 1
    fi

    log_success "Installed kanata: $(command -v kanata)"
}

install_driverkit_pkg() {
    require_cmd curl
    require_cmd installer

    local pkg_url="$DRIVERKIT_PKG_URL"

    if [[ -z "$pkg_url" ]]; then
        log_info "Resolving Karabiner DriverKit VirtualHIDDevice pkg URL from GitHub..."
        pkg_url="$(get_driverkit_pkg_url_from_github || true)"

        if [[ -z "$pkg_url" || "$pkg_url" == "null" ]]; then
            log_error "Could not determine the DriverKit pkg URL via GitHub API."
            log_info "Set DRIVERKIT_PKG_URL to the .pkg download URL and rerun."
            exit 1
        fi
    fi

    log_info "Downloading DriverKit pkg: $pkg_url"

    local tmp_pkg
    tmp_pkg="$(mktemp "${TMPDIR:-/tmp}/Karabiner-DriverKit-VirtualHIDDevice.XXXXXX.pkg")"

    curl -fL --retry 3 --retry-delay 2 -o "$tmp_pkg" "$pkg_url"

    log_info "Installing DriverKit pkg (requires sudo)..."
    sudo installer -pkg "$tmp_pkg" -target /

    rm -f "$tmp_pkg"

    log_success "Installed Karabiner DriverKit VirtualHIDDevice package"
}

configure_launchd() {
    require_cmd launchctl

    local kanata_bin
    kanata_bin="$(command -v kanata)"

    # Expand config path now (LaunchDaemons will not have the same $HOME).
    local kanata_cfg_expanded
    kanata_cfg_expanded="$(expand_path "$KANATA_CFG")"

    if [[ ! -f "$kanata_cfg_expanded" ]]; then
        log_warning "Kanata config not found at: $kanata_cfg_expanded"
        log_warning "Kanata will likely fail to start until you create/symlink the config."
    fi

    sudo mkdir -p "$LOG_DIR"
    sudo chmod 0755 "$LOG_DIR"

    # Ensure DriverKit binaries exist (best-effort check; paths can vary by version)
    if [[ ! -x "$VHID_MANAGER_BIN" ]]; then
        log_warning "Karabiner VirtualHIDDevice Manager not found at: $VHID_MANAGER_BIN"
        log_warning "If the pkg was installed successfully, verify the path or set VHID_MANAGER_BIN."
    fi

    if [[ ! -x "$VHID_DAEMON_BIN" ]]; then
        log_warning "Karabiner VirtualHIDDevice Daemon not found at: $VHID_DAEMON_BIN"
        log_warning "If the pkg was installed successfully, verify the path or set VHID_DAEMON_BIN."
    fi

    # 1) Manager activation job
    write_plist "$PLIST_VHID_MANAGER" "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key>
  <string>${LABEL_VHID_MANAGER}</string>
  <key>RunAtLoad</key>
  <true/>
  <key>ProgramArguments</key>
  <array>
    <string>${VHID_MANAGER_BIN}</string>
    <string>activate</string>
  </array>
  <key>StandardOutPath</key>
  <string>${LOG_DIR}/vhidmanager.out.log</string>
  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/vhidmanager.err.log</string>
</dict>
</plist>
"

    # 2) VirtualHID daemon job
    write_plist "$PLIST_VHID_DAEMON" "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key>
  <string>${LABEL_VHID_DAEMON}</string>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>ProcessType</key>
  <string>Interactive</string>
  <key>ProgramArguments</key>
  <array>
    <string>${VHID_DAEMON_BIN}</string>
  </array>
  <key>StandardOutPath</key>
  <string>${LOG_DIR}/vhiddaemon.out.log</string>
  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/vhiddaemon.err.log</string>
</dict>
</plist>
"

    # 3) Kanata job
    local -a kanata_args
    kanata_args=("$kanata_bin" "--cfg" "$kanata_cfg_expanded")

    if [[ -n "$KANATA_PORT" ]]; then
        kanata_args+=("--port" "$KANATA_PORT")
    fi

    if [[ -n "$KANATA_EXTRA_ARGS" ]]; then
        # Note: split on spaces; use with care.
        # shellcheck disable=SC2206
        kanata_args+=( $KANATA_EXTRA_ARGS )
    fi

    # Convert args array to plist XML
    local plist_args_xml=""
    local arg
    for arg in "${kanata_args[@]}"; do
        plist_args_xml+="    <string>${arg}</string>\n"
    done

    write_plist "$PLIST_KANATA" "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key>
  <string>${LABEL_KANATA}</string>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>ProgramArguments</key>
  <array>
${plist_args_xml}  </array>
  <key>StandardOutPath</key>
  <string>${LOG_DIR}/kanata.out.log</string>
  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/kanata.err.log</string>
</dict>
</plist>
"

    log_info "Bootstrapping launchd services (requires sudo)..."
    launchd_bootstrap_enable_kickstart "$PLIST_VHID_MANAGER" "$LABEL_VHID_MANAGER"
    launchd_bootstrap_enable_kickstart "$PLIST_VHID_DAEMON" "$LABEL_VHID_DAEMON"
    launchd_bootstrap_enable_kickstart "$PLIST_KANATA" "$LABEL_KANATA"

    log_success "launchd services installed and started"
}

print_manual_steps() {
    local kanata_bin
    kanata_bin="$(command -v kanata)"

    cat <<EOF

Manual steps required (cannot be fully automated by a script):

1) Approve the DriverKit system extension:
   - Open the Karabiner VirtualHIDDevice Manager app:
       open -a "/Applications/.Karabiner-VirtualHIDDevice-Manager"
   - In System Settings -> Login Items & Extensions, allow/enable the extension if prompted.

2) Grant Privacy permissions to kanata:
   - System Settings -> Privacy & Security -> Accessibility: add/enable:
       $kanata_bin
   - System Settings -> Privacy & Security -> Input Monitoring: add/enable:
       $kanata_bin

3) If kanata is not taking effect, check logs:
   - $LOG_DIR/kanata.err.log
   - $LOG_DIR/vhiddaemon.err.log

EOF

    log_warning "After completing the approvals above, you may need to reboot or restart the services."
    log_info "To restart services: sudo launchctl kickstart -k system/${LABEL_KANATA}"
}

main() {
    log_info "Installing Kanata + Karabiner DriverKit VirtualHIDDevice (minimal)"

    # Fail-fast dependencies
    require_cmd brew "See scripts/brew_install.sh"
    require_cmd curl
    require_cmd sudo
    require_cmd installer
    require_cmd launchctl

    if [[ -z "$DRIVERKIT_PKG_URL" ]]; then
        require_cmd jq "brew install jq"
    fi

    install_kanata
    install_driverkit_pkg
    configure_launchd
    print_manual_steps

    log_success "Install complete"
}

main "$@"
