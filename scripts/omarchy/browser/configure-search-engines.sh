#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../../utils/utils_logging.sh"

POLICY_FILE="$SCRIPT_DIR/search-engines.json"
POLICY_NAME="pszponder-search-engines.json"

for browser in chromium google-chrome google-chrome-stable brave brave-browser microsoft-edge-stable helium-browser; do
  command -v "$browser" >/dev/null 2>&1 || continue

  case "$browser" in
    chromium) policy_dir=/etc/chromium/policies/managed ;;
    google-chrome|google-chrome-stable) policy_dir=/etc/opt/chrome/policies/managed ;;
    brave|brave-browser) policy_dir=/etc/brave/policies/managed ;;
    microsoft-edge-stable) policy_dir=/etc/opt/edge/policies/managed ;;
    helium-browser) policy_dir=/etc/chromium/policies/managed ;;
  esac

  log_info "Installing custom search engines for $browser..."
  sudo install -d -m 0755 "$policy_dir"
  sudo install -m 0644 "$POLICY_FILE" "$policy_dir/$POLICY_NAME"
done
