#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
NIX_DIR="$ROOT_DIR/nix"

log_info() {
    printf '%b\n' "ℹ️ [INFO] $*"
}

log_success() {
    printf '%b\n' "✅ [OK] $*"
}

log_error() {
    printf '%b\n' "❌ [ERROR] $*" >&2
}

if [[ ! -f "$NIX_DIR/flake.nix" ]]; then
    log_error "No Nix flake found at $NIX_DIR/flake.nix."
    log_error "Run this script from a checkout containing the system flake."
    exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
    log_error "Nix is not installed or is not on PATH."
    exit 1
fi

log_info "Updating Nix flake inputs in '$NIX_DIR'..."
nix flake update --flake "$NIX_DIR"
log_success "Nix flake inputs updated successfully."

if ! git -C "$ROOT_DIR" diff --quiet -- nix/flake.lock; then
    log_info "nix/flake.lock changed. Review and commit it before rebuilding:"
    log_info "  chezmoi git -- diff -- nix/flake.lock"
    log_info "  chezmoi git -- add nix/flake.lock"
    log_info "  chezmoi git -- commit -m \"nix: update flake inputs\""
fi
