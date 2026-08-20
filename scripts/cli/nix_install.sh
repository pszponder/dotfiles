#!/bin/sh
set -eu

if [ -x /nix/nix-installer ]; then
  printf '%s\n' 'Nix is already installed, skipping'
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  printf '%s\n' 'curl is required to install Nix' >&2
  exit 1
fi

curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes --no-confirm
printf '%s\n' 'Nix installed with nix-command and flakes enabled'