#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping plugin installation."
  exit 0
fi

log_info "Installing Plugins for Omarchy..."

plugin_id="robzolkos.github"
plugin_url="https://github.com/robzolkos/omarchy-github.git"
plugin_dir="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/$plugin_id"

if [ -f "$plugin_dir/manifest.json" ]; then
  log_info "$plugin_id is already installed. Ensuring it is enabled..."
  omarchy plugin enable "$plugin_id"
else
  log_info "Installing $plugin_id..."
  omarchy plugin add "$plugin_url" --enable --yes
fi

log_success "Omarchy plugin installation complete."
