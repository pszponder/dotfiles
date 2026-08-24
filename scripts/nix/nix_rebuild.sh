#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
NIX_DIR="$ROOT_DIR/nix"

. "$SCRIPT_DIR/../utils/utils_logging.sh"

if command -v scutil >/dev/null 2>&1; then
    hostname="$(scutil --get LocalHostName 2>/dev/null || hostname -s 2>/dev/null || hostname)"
else
    hostname="$(hostname -s 2>/dev/null || hostname)"
fi

if [[ ! -f "$NIX_DIR/flake.nix" ]]; then
    log_error "No Nix flake found at $NIX_DIR/flake.nix."
    log_error "Run this script from a checkout containing the system flake."
    exit 1
fi

flake_ref="$NIX_DIR#$hostname"
class=''

if command -v darwin-rebuild >/dev/null 2>&1; then
    class='darwin'
    log_info "Applying $class configuration for host '$hostname'..."
    darwin-rebuild switch --flake "$flake_ref"
elif command -v nixos-rebuild >/dev/null 2>&1; then
    class='nixos'
    log_info "Applying $class configuration for host '$hostname'..."
    sudo nixos-rebuild switch --flake "$flake_ref"
else
    log_error "Neither darwin-rebuild nor nixos-rebuild is on PATH."
    exit 1
fi

log_success "Nix system configuration applied successfully."
