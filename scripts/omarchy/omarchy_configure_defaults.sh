#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

log_info "Configuring Omarchy defaults..."

"$SCRIPT_DIR/omarchy_set_nerdfonts.sh"

# Set the default color theme
omarchy theme set Catppuccin