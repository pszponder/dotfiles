#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping GUI installation."
  exit 0
fi

log_info "Installing GUI application(s) for Omarchy..."

log_info "Installing Ghostty..."
omarchy install terminal ghostty