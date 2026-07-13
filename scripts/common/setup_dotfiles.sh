#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOTS_DIR="$ROOT_DIR/dots"

# shellcheck source=utils_logging.sh
source "$SCRIPT_DIR/utils_logging.sh"

########################################
# Ensure GNU Stow is installed
########################################
if command -v stow >/dev/null 2>&1; then
    log_success "GNU Stow is installed."
else
    log_error "GNU Stow is not installed."
    exit 1
fi

########################################
# Verify dots directory exists
########################################
if [[ ! -d "$DOTS_DIR" ]]; then
    log_error "Dotfiles directory not found: $DOTS_DIR"
    exit 1
fi

########################################
# Stow dotfiles
########################################
log_info "Installing dotfiles..."

(
    cd "$ROOT_DIR"

    stow \
        --target="$HOME" \
        --restow \
        dots
)

log_success "Dotfiles installed successfully."