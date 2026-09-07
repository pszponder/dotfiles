#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

log_info "Installing CLI application(s) for Omarchy..."

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping system CLI installation."
  exit 0
fi

# These are global workstation tools. Keep their binaries and updates under
# pacman instead of duplicating them in the Omarchy mise environment.
omarchy pkg add \
  atuin \
  cmake \
  direnv \
  git-delta \
  jujutsu \
  just \
  worktrunk \
  yazi

log_success "Installed system-managed CLI tools."
