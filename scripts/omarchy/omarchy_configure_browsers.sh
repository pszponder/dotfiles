#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping browser configuration."
  exit 0
fi

experimental_flags=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --experimental-flags)
      experimental_flags=true
      ;;
    --help|-h)
      printf '%s\n' "Usage: $0 [--experimental-flags]"
      exit 0
      ;;
    *)
      log_error "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

log_info "Configuring Chromium-family browsers..."

"$SCRIPT_DIR/browser/configure-flags.sh"
"$SCRIPT_DIR/browser/configure-search-engines.sh"

if [ "$experimental_flags" = true ]; then
  "$SCRIPT_DIR/browser/configure-experimental-flags.sh"
else
  log_info "Skipping experimental chrome://flags entries (use --experimental-flags to enable)."
fi

POLICY_FILE="$SCRIPT_DIR/browser/chromium-policy.json"
POLICY_NAME="pszponder.json"

# Omarchy and Chromium-family browsers use different policy roots. Only
# configure browsers that are actually installed on this machine.
for browser in chromium google-chrome google-chrome-stable brave brave-browser microsoft-edge-stable helium-browser; do
  command -v "$browser" >/dev/null 2>&1 || continue

  case "$browser" in
    chromium) policy_dir=/etc/chromium/policies/managed ;;
    google-chrome|google-chrome-stable) policy_dir=/etc/opt/chrome/policies/managed ;;
    brave|brave-browser) policy_dir=/etc/brave/policies/managed ;;
    microsoft-edge-stable) policy_dir=/etc/opt/edge/policies/managed ;;
    helium-browser) policy_dir=/etc/chromium/policies/managed ;;
  esac

  log_info "Installing browser policy for $browser..."
  sudo install -d -m 0755 "$policy_dir"
  sudo install -m 0644 "$POLICY_FILE" "$policy_dir/$POLICY_NAME"
done

log_success "Chromium-family browser configuration complete."
