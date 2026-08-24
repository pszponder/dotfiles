#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if [ -x /nix/nix-installer ]; then
  log_info 'Nix is already installed, skipping'
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  log_error 'curl is required to install Nix'
  exit 1
fi

curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes --no-confirm
log_success 'Nix installed with nix-command and flakes enabled'