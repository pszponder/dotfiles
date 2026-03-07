#!/usr/bin/env bash
set -euo pipefail

# Usage: setup_nerdfonts.sh <FontName> [FontName ...]
# Font names must match the GitHub release zip names (e.g. CaskaydiaCove, FiraCode)

NERD_FONTS_VERSION="v3.4.0"
NERD_FONTS_BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}"

if [[ $# -eq 0 ]]; then
  echo "⚠️ No font names provided, skipping."
  exit 0
fi

# Determine font directory
if [[ "$(uname -s)" == "Darwin" ]]; then
  FONT_DIR="$HOME/Library/Fonts"
else
  FONT_DIR="$HOME/.local/share/fonts"
fi
mkdir -p "$FONT_DIR"

installed_any=false

for font_name in "$@"; do
  # Check if font is already installed
  if fc-list 2>/dev/null | grep -qi "$font_name"; then
    echo "✅ $font_name Nerd Font is already installed."
    continue
  fi

  echo "📥 Downloading $font_name Nerd Font..."
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
