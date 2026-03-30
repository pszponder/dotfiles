#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/utils_logging.sh
source "$SCRIPT_DIR/../common/utils_logging.sh"

########################################
# Only run on macOS
########################################
if [[ "$(uname -s)" != "Darwin" ]]; then
  log_info "Non-macOS system detected, skipping Homebrew installation."
  exit 0
fi

log_info "macOS detected, proceeding with Homebrew installation."

########################################
# Install Homebrew if not present
########################################
if command -v brew >/dev/null 2>&1; then
  log_success "Homebrew is already installed, skipping."
else
  log_info "Installing Homebrew..."

  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    log_success "Homebrew installation complete."
  else
    log_error "Homebrew installation failed."
    exit 1
  fi
fi

#########################################
# Ensure brew is available in this script
#########################################
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  log_error "Homebrew installed but brew not found in expected locations."
  exit 1
fi

log_success "Homebrew is ready to use."

########################################
# Update Homebrew
########################################
log_info "Updating Homebrew..."
brew update
log_success "Homebrew update complete."

#############################################
# Install packages from Brewfile (if present)
#############################################
BREWFILE_PATH="$SCRIPT_DIR/Brewfile"

if [[ -f "$BREWFILE_PATH" ]]; then
  log_info "Brewfile found at $BREWFILE_PATH. Installing packages..."

  if brew bundle --file="$BREWFILE_PATH"; then
    log_success "Brewfile packages installed successfully."
  else
    log_error "Brewfile installation failed."
    exit 1
  fi
else
  log_info "No Brewfile found at $BREWFILE_PATH. Skipping package installation."
fi

########################################
# Cleanup
########################################
log_info "Running brew cleanup..."
brew cleanup
log_success "Homebrew cleanup complete."