#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/utils_logging.sh
source "$SCRIPT_DIR/../common/utils_logging.sh"

# ===================================
# Only run on Linux
# ===================================
OS_NAME="$(uname -s)"
if [[ "$OS_NAME" == "Darwin" ]]; then
  log_info "macOS detected, skipping Nerd Fonts installation (use Homebrew instead)."
  exit 0
fi

# ===================================
# Usage: install_nerdfonts-linux.sh [--force] <FontName> [FontName ...]
# Font names must match the GitHub release zip names (e.g. CaskaydiaCove, FiraCode)
# ===================================
NERD_FONTS_VERSION="v3.4.0"
NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}"

FORCE_INSTALL=false
fonts=()

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --force)
      FORCE_INSTALL=true
      ;;
    *)
      fonts+=("$arg")
      ;;
  esac
done

if [[ "${#fonts[@]}" -eq 0 ]]; then
  log_warn "No font names provided, skipping."
  exit 0
fi

# Determine font directory
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

installed_any=false

for font_name in "${fonts[@]}"; do
  # Check if font is already installed
  if fc-list 2>/dev/null | grep -qi "$font_name"; then
    if [[ "$FORCE_INSTALL" == true ]]; then
      log_info "Reinstalling $font_name Nerd Font due to --force flag..."
    else
      log_success "$font_name Nerd Font is already installed."
      continue
    fi
  else
    log_info "Installing $font_name Nerd Font..."
  fi

  tmpdir=$(mktemp -d)
  zip_file="$tmpdir/${font_name}.zip"

  if ! curl -fsSL -o "$zip_file" "${NERD_FONTS_BASE_URL}/${font_name}.zip"; then
    log_warn "Failed to download $font_name, skipping."
    rm -rf "$tmpdir"
    continue
  fi

  unzip -qo "$zip_file" -d "$FONT_DIR" '*.ttf' '*.otf' 2>/dev/null || true

  rm -rf "$tmpdir"
  installed_any=true
  log_success "$font_name Nerd Font installed."
done

# Rebuild font cache if any fonts were installed
if [[ "$installed_any" == true ]] && command -v fc-cache >/dev/null 2>&1; then
  log_info "Rebuilding font cache..."
  fc-cache -f
fi

log_success "Nerd Fonts setup complete."