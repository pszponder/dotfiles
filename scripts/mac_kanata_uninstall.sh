#!/usr/bin/env bash
set -euo pipefail

# mac_kanata_uninstall.sh
#
# What this script removes
# - The launchd LaunchDaemons (system services) created by scripts/mac_kanata_install.sh.
#   This stops kanata + the VirtualHIDDevice services from starting at boot.
#
# Optional removals (enabled by default)
# - REMOVE_KANATA=1: uninstall kanata from Homebrew.
# - REMOVE_DRIVERKIT=1: run the DriverKit package's own uninstall scripts (if present).
# - REMOVE_LOGS=1: delete /Library/Logs/Kanata.
#
# You can keep things installed by overriding to 0, e.g.:
#   REMOVE_KANATA=0 REMOVE_DRIVERKIT=0 REMOVE_LOGS=0 ./scripts/mac_kanata_uninstall.sh
#
# Note: macOS Privacy permissions (Accessibility/Input Monitoring) are user-managed and
# are not removed automatically.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
# shellcheck source=./utils_logging.sh
source "$SCRIPT_DIR/utils_logging.sh"
# shellcheck source=./utils_env.sh
source "$SCRIPT_DIR/utils_env.sh"

if [[ "${OSTYPE:-}" != darwin* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

load_config_env

LAUNCHD_LABEL_PREFIX=${LAUNCHD_LABEL_PREFIX:-com.pszponder.kanata}
PLIST_DIR=${PLIST_DIR:-/Library/LaunchDaemons}
LOG_DIR=${LOG_DIR:-/Library/Logs/Kanata}

LABEL_VHID_MANAGER="${LAUNCHD_LABEL_PREFIX}.karabiner-vhidmanager"
LABEL_VHID_DAEMON="${LAUNCHD_LABEL_PREFIX}.karabiner-vhiddaemon"
LABEL_KANATA="${LAUNCHD_LABEL_PREFIX}.daemon"

PLIST_VHID_MANAGER="${PLIST_DIR}/${LABEL_VHID_MANAGER}.plist"
PLIST_VHID_DAEMON="${PLIST_DIR}/${LABEL_VHID_DAEMON}.plist"
PLIST_KANATA="${PLIST_DIR}/${LABEL_KANATA}.plist"

# Defaults: perform a "clean" removal.
REMOVE_KANATA=${REMOVE_KANATA:-1}
REMOVE_DRIVERKIT=${REMOVE_DRIVERKIT:-1}
REMOVE_LOGS=${REMOVE_LOGS:-1}

bootout_if_present() {
    local plist="$1"
    if [[ -f "$plist" ]]; then
        sudo launchctl bootout system "$plist" >/dev/null 2>&1 || true
    fi
}

rm_if_present() {
    local p="$1"
    if [[ -e "$p" ]]; then
        sudo rm -f "$p"
    fi
}

uninstall_driverkit_files_if_requested() {
    if [[ "$REMOVE_DRIVERKIT" != "1" ]]; then
        return 0
    fi

    log_warning "REMOVE_DRIVERKIT=1 set: attempting to uninstall Karabiner DriverKit VirtualHIDDevice files"

    local base="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
    local deactivate="$base/scripts/uninstall/deactivate_driver.sh"
    local remove_files="$base/scripts/uninstall/remove_files.sh"

    if [[ -x "$deactivate" ]]; then
        log_info "Deactivating DriverKit driver..."
        sudo bash "$deactivate" || true
    else
        log_warning "Deactivate script not found: $deactivate"
    fi

    if [[ -x "$remove_files" ]]; then
        log_info "Removing DriverKit installed files..."
        sudo bash "$remove_files" || true
    else
        log_warning "Remove-files script not found: $remove_files"
    fi

    sudo killall Karabiner-VirtualHIDDevice-Daemon >/dev/null 2>&1 || true
}

uninstall_kanata_if_requested() {
    if [[ "$REMOVE_KANATA" != "1" ]]; then
        return 0
    fi

    if ! command -v brew >/dev/null 2>&1; then
        log_warning "brew not found; cannot uninstall kanata automatically."
        return 0
    fi

    if brew list --formula 2>/dev/null | grep -q '^kanata$'; then
        log_info "Uninstalling kanata via Homebrew..."
        brew uninstall kanata
    else
        log_info "kanata not installed via Homebrew (or not installed)."
    fi
}

main() {
    log_info "Stopping launchd services (requires sudo)..."

    bootout_if_present "$PLIST_KANATA"
    bootout_if_present "$PLIST_VHID_DAEMON"
    bootout_if_present "$PLIST_VHID_MANAGER"

    log_info "Removing launchd plists..."
    rm_if_present "$PLIST_KANATA"
    rm_if_present "$PLIST_VHID_DAEMON"
    rm_if_present "$PLIST_VHID_MANAGER"

    uninstall_driverkit_files_if_requested
    uninstall_kanata_if_requested

    if [[ "$REMOVE_LOGS" == "1" ]]; then
        if [[ -d "$LOG_DIR" ]]; then
            log_info "Removing logs at $LOG_DIR"
            sudo rm -rf "$LOG_DIR"
        fi
    fi

    log_success "Uninstall complete"

    cat <<EOF

Notes:
- macOS Privacy permissions are not removed automatically. To fully clean up:
  - System Settings -> Privacy & Security -> Accessibility: remove/disable kanata
  - System Settings -> Privacy & Security -> Input Monitoring: remove/disable kanata
- This script defaults to a clean removal (kanata + driverkit + logs).
- To keep installed packages/logs, override any of these to 0:
    REMOVE_DRIVERKIT=0 REMOVE_KANATA=0 REMOVE_LOGS=0 $0

EOF
}

main "$@"
