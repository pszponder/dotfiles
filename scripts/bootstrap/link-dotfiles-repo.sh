#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
LINK_PATH="$HOME/repos/github/pszponder/dotfiles"

if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
  log_info "Skipping existing path: $LINK_PATH"
  exit 0
fi

ln -s "$REPO_ROOT" "$LINK_PATH"
log_success "Linked $LINK_PATH -> $REPO_ROOT"