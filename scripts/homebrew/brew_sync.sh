#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../common/utils_logging.sh
source "$SCRIPT_DIR/../common/utils_logging.sh"

########################################
# Ensure Homebrew is installed
########################################
if command -v brew >/dev/null 2>&1; then
    log_success "Homebrew is installed."
else
    log_error "Homebrew is not installed. Run brew_install.sh first."
    exit 1
fi

########################################
# Ensure brew is available in this script
########################################
if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    log_error "Homebrew is installed but brew was not found in expected locations."
    exit 1
fi

########################################
# Sync packages from Brewfile
########################################
BREWFILE_PATH="$SCRIPT_DIR/Brewfile"

if [[ -f "$BREWFILE_PATH" ]]; then
    log_info "Syncing packages from Brewfile..."

    brew update
    brew bundle --file="$BREWFILE_PATH" --cleanup

    log_success "Homebrew sync completed successfully."
else
    log_error "No Brewfile found at $BREWFILE_PATH."
    exit 1
fi
