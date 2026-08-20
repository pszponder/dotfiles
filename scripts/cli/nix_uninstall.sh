#!/bin/sh
set -eu

if [ ! -x /nix/nix-installer ]; then
  printf '%s\n' 'Nix installed by the NixOS installer was not found, skipping'
  exit 0
fi

/nix/nix-installer uninstall --no-confirm
printf '%s\n' 'Nix uninstalled'