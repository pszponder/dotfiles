#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

log_info "Installing apps and tools for Omarchy..."

"$SCRIPT_DIR/.omarchy_install_tui.sh"
"$SCRIPT_DIR/omarchy_install_webapp.sh"