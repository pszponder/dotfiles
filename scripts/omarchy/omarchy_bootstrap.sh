#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

log_info "Bootstrapping Omarchy..."

"$SCRIPT_DIR/omarchy_debloat.sh"
"$SCRIPT_DIR/omarchy_install.sh"
"$SCRIPT_DIR/omarchy_configure_defaults.sh"