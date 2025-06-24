#!/usr/bin/env bash

set -euo pipefail

# List of fonts to install
FONTS=(
  "JetBrainsMono"
  "CascadiaCode"
  "ComicShannsMono"
  "Meslo"
  "NerdFontsSymbolsOnly"
)

NERD_FONT_VERSION="3.4.0" # NOTE: Update this version as needed
BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONT_VERSION}"

FONT_BASE_DIR="${HOME}/.local/share/fonts/NerdFonts"

mkdir -p "$FONT_BASE_DIR"
cd "$FONT_BASE_DIR"

for FONT in "${FONTS[@]}"; do
  FONT_DIR="${FONT_BASE_DIR}/${FONT}"

  # Check if font directory exists and is not empty
  if [[ -d "$FONT_DIR" && "$(find "$FONT_DIR" -type f -name '*.ttf' | wc -l)" -gt 0 ]]; then
    echo "✅ ${FONT} Nerd Font already installed. Skipping."
    continue
  fi

  echo "⬇️ Installing ${FONT} Nerd Font..."

  # Download and extract font
  wget -q "${BASE_URL}/${FONT}.zip" -O "${FONT}.zip"
  unzip -o "${FONT}.zip" -d "${FONT}"
  rm "${FONT}.zip"
done

echo "🗂 Updating font cache..."
fc-cache -fv "$FONT_BASE_DIR"

echo "✅ All requested Nerd Fonts installed (skipping existing)."
