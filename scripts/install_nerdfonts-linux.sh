#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Only run on Linux
# ===================================
OS_NAME="$(uname -s)"
if [[ "$OS_NAME" == "Darwin" ]]; then
  echo "⏭ macOS detected, skipping Nerd Fonts installation (use Homebrew instead)."
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
  echo "⚠️ No font names provided, skipping."
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
      echo "♻️ Reinstalling $font_name Nerd Font due to --force flag..."
    else
      echo "✅ $font_name Nerd Font is already installed."
      continue
    fi
  else
    echo "📥 Installing $font_name Nerd Font..."
  fi

  tmpdir=$(mktemp -d)
  zip_file="$tmpdir/${font_name}.zip"

  if ! curl -fsSL -o "$zip_file" "${NERD_FONTS_BASE_URL}/${font_name}.zip"; then
    echo "⚠️ Failed to download $font_name, skipping."
    rm -rf "$tmpdir"
    continue
  fi

  echo "📦 Installing $font_name Nerd Font..."
  unzip -qo "$zip_file" -d "$FONT_DIR" '*.ttf' '*.otf' 2>/dev/null || true

  rm -rf "$tmpdir"
  installed_any=true
  echo "✅ $font_name Nerd Font installed."
done

# Rebuild font cache if any fonts were installed
if [[ "$installed_any" == true ]] && command -v fc-cache >/dev/null 2>&1; then
  echo "🔄 Rebuilding font cache..."
  fc-cache -f
fi

echo "✅ Nerd Fonts setup complete."