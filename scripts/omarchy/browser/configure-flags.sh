#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../../utils/utils_logging.sh"

append_flag() {
  file=$1
  flag=$2

  mkdir -p "$(dirname -- "$file")"
  touch "$file"

  if ! grep -Fqx -- "$flag" "$file"; then
    [ ! -s "$file" ] || [ "$(tail -c 1 "$file")" = "" ] || printf '\n' >>"$file"
    printf '%s\n' "$flag" >>"$file"
  fi
}

# These are stable Omarchy/browser integration flags. Existing Omarchy flags
# and extension entries are preserved; this script only adds missing lines.
for browser in chromium chrome google-chrome google-chrome-stable brave brave-beta brave-nightly brave-origin brave-origin-beta microsoft-edge-stable helium-browser; do
  flags_file="$HOME/.config/$browser-flags.conf"

  case "$browser" in
    chromium) command -v chromium >/dev/null 2>&1 || continue ;;
    chrome) command -v google-chrome >/dev/null 2>&1 || continue ;;
    google-chrome|google-chrome-stable) command -v "$browser" >/dev/null 2>&1 || continue ;;
    brave*) command -v brave >/dev/null 2>&1 || continue ;;
    microsoft-edge-stable) command -v microsoft-edge-stable >/dev/null 2>&1 || continue ;;
    helium-browser) command -v helium-browser >/dev/null 2>&1 || continue ;;
  esac

  append_flag "$flags_file" '--ozone-platform=wayland'
  append_flag "$flags_file" '--ozone-platform-hint=wayland'
  append_flag "$flags_file" '--password-store=gnome-libsecret'
  log_success "Updated $flags_file"
done

# chrome://flags entries are intentionally not written here. Their persisted
# names are Chromium-version-specific and can change or disappear. Keep those
# entries in a separately versioned migration once their current internal
# names have been verified against the installed Chromium release.
