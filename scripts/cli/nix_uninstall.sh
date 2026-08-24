#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if [ ! -x /nix/nix-installer ]; then
  log_info 'Nix installed by the NixOS installer was not found, skipping'
  exit 0
fi

/nix/nix-installer uninstall --no-confirm
log_success 'Nix uninstalled'