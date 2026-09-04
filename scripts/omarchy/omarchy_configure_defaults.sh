#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping default configuration."
  exit 0
fi

log_info "Configuring Omarchy defaults..."

log_info "Setting the default terminal to Ghostty..."
omarchy default terminal ghostty

# Set the default color theme
log_info "Setting the default color theme to Catppuccin..."
omarchy theme set Catppuccin

# TODO: Set default background image

# Set the default font
log_info "Setting the default font to CaskaydiaCove Nerd Font..."
omarchy font set "CaskaydiaCove Nerd Font"

# TODO: Set default Terminal

# TODO: Set default Editor

# TODO: Set default Browser