#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_error "Omarchy is not available. This script is for Omarchy systems."
  exit 1
fi

if ! omarchy pkg present zsh; then
  log_info "Installing zsh..."
  omarchy pkg add zsh
fi

zsh_path=$(command -v zsh)

if ! grep -Fqx "$zsh_path" /etc/shells; then
  log_info "Registering $zsh_path as a valid login shell..."
  printf '%s\n' "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

current_shell=$(getent passwd "$USER" | cut -d: -f7)
if [ "$current_shell" = "$zsh_path" ]; then
  log_success "zsh is already the default shell."
  exit 0
fi

chsh -s "$zsh_path"
log_success "Default shell changed to zsh. Log out and back in for it to take effect."
