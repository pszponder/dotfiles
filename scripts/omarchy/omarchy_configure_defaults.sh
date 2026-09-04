#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

log_info "Configuring Omarchy defaults..."
 
# Install Ghostty and use it for Omarchy-launched terminals.
if command -v omarchy >/dev/null 2>&1; then
  if command -v ghostty >/dev/null 2>&1; then
    if [ "$(omarchy default terminal)" != "ghostty" ]; then
      omarchy default terminal ghostty
    fi
  else
    omarchy install terminal ghostty
  fi
else
  log_warn "Omarchy is not available; leaving the default terminal unchanged."
fi

# Set the default color theme
omarchy theme set Catppuccin

# TODO: Set default background image

# Set the default font
omarchy font set "CaskaydiaCove Nerd Font"

# TODO: Set default Terminal

# TODO: Set default Editor

# TODO: Set default Browser