#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../common/utils_logging.sh
source "$SCRIPT_DIR/../common/utils_logging.sh"

########################################
# Install mise if not present
########################################
if command -v mise >/dev/null 2>&1; then
    log_success "mise is already installed, skipping."
else
    log_info "Installing mise..."

    if curl https://mise.run | sh; then
        log_success "mise installation complete."
    else
        log_error "mise installation failed."
        exit 1
    fi
fi

########################################
# Ensure mise is available in this script
########################################
if [[ -x "$HOME/.local/bin/mise" ]]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
else
    log_error "mise installed but executable not found."
    exit 1
fi

log_success "mise is ready to use."

########################################
# Install bootstrap tools
########################################
BOOTSTRAP_MISE_FILE="$SCRIPT_DIR/mise.toml"

log_info "Installing bootstrap tools..."

if MISE_GLOBAL_CONFIG_FILE="$BOOTSTRAP_MISE_FILE" mise install; then
    log_success "Bootstrap tools installed successfully."
else
    log_error "Failed to install bootstrap tools."
    exit 1
fi