#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping service installation."
  exit 0
fi

log_info "Installing and configuring Tailscale for Omarchy..."
omarchy install service tailscale
log_success "Tailscale installation complete."

log_info "Installing and configuring Dropbox for Omarchy..."
omarchy install service dropbox
log_success "Dropbox installation complete. Authenticate from the Dropbox tray menu."
