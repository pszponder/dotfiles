#!/usr/bin/env bash

set -euo pipefail

# List of fonts to install
FONTS=(
  "JetBrainsMono"
  "CascadiaCode"
  "ComicShannsMono"
  "Meslo"
  "Symbols Only"
)

NERD_FONT_VERSION="3.4.0"
BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONT_VERSION}"

FONT_BASE_DIR="${HOME}/.local/share/fonts/NerdFonts"

mkdir -p "$FONT_BASE_DIR"
cd "$FONT_BASE_DIR"

for FONT in "${FONTS[@]}"; do
  echo "⬇️ Installing ${FONT} Nerd Font..."

  # Download and extract font
  wget -q "${BASE_URL}/${FONT}.zip" -O "${FONT}.zip"
  unzip -o "${FONT}.zip" -d "${FONT}"
  rm "${FONT}.zip"
done

echo "🗂 Updating font cache..."
fc-cache -fv "$FONT_BASE_DIR"

echo "✅ All requested Nerd Fonts installed successfully."
