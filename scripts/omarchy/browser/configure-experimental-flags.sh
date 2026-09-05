#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../../utils/utils_logging.sh"

command -v jq >/dev/null 2>&1 || {
  log_error "jq is required to configure experimental Chromium flags."
  exit 1
}

flags='["side-panel-flyover-animation@1","vertical-tabs-expand-on-hover@1","vertical-tabs-grab-handle-removal@1","vertical-tabs@1"]'

configure_state() {
  browser=$1
  state=$2
  process=$3

  [ -f "$state" ] || return 0

  if pgrep -x "$process" >/dev/null 2>&1; then
    log_warn "$browser is running; close it before changing $state."
    return 0
  fi

  backup="$state.bak.$(date +%Y%m%d%H%M%S)"
  temporary=$(mktemp "$state.tmp.XXXXXX")
  trap 'rm -f "$temporary"' EXIT HUP INT TERM

  jq --argjson flags "$flags" \
    '.browser = (.browser // {})
     | .browser.enabled_labs_experiments =
       (((.browser.enabled_labs_experiments // []) + $flags) | unique)' \
    "$state" >"$temporary"

  if cmp -s "$state" "$temporary"; then
    rm -f "$temporary"
    trap - EXIT HUP INT TERM
    log_info "$browser experimental flags are already enabled."
    return 0
  fi

  cp -p "$state" "$backup"
  chmod --reference="$state" "$temporary"
  mv -f "$temporary" "$state"
  trap - EXIT HUP INT TERM
  log_success "Enabled experimental flags for $browser (backup: $backup)."
}

configure_state "Chromium" "$HOME/.config/chromium/Local State" chromium
configure_state "Google Chrome" "$HOME/.config/google-chrome/Local State" google-chrome
configure_state "Brave" "$HOME/.config/BraveSoftware/Brave-Browser/Local State" brave
configure_state "Microsoft Edge" "$HOME/.config/microsoft-edge/Local State" microsoft-edge-stable
configure_state "Helium" "$HOME/.config/net.imput.helium/Local State" helium-browser
