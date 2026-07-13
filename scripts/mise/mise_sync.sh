#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../common/utils_logging.sh
source "$SCRIPT_DIR/../common/utils_logging.sh"

########################################
# Ensure mise is installed
########################################
if command -v mise >/dev/null 2>&1; then
    log_success "mise is installed."
else
    log_error "mise is not installed. Run mise_install.sh first."
    exit 1
fi

########################################
# Ensure user config exists
########################################
MISE_CONFIG="$HOME/.config/mise/config.toml"

if [[ ! -f "$MISE_CONFIG" ]]; then
    log_error "mise config not found: $MISE_CONFIG"
    exit 1
fi

########################################
# Trust and install tools
########################################
log_info "Trusting mise configuration..."

mise trust "$MISE_CONFIG"

log_info "Installing CLI tools from $MISE_CONFIG..."

mise install

log_success "CLI tools installed successfully."