#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info "Starting macOS bootstrap process..."

"$SCRIPT_DIR/common/setup_directories.sh"
"$SCRIPT_DIR/homebrew/brew_install.sh"
"$SCRIPT_DIR/homebrew/brew_sync.sh"
"$SCRIPT_DIR/mise/mise_install.sh"
"$SCRIPT_DIR/common/setup_dotfiles.sh"
"$SCRIPT_DIR/mise/mise_sync.sh"

log_success "macOS bootstrap process completed successfully!"