#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

log_info "Installing and configuring Nerd Fonts for Omarchy..."

# Nerd Fonts to install. The last font will be set as the system font.
fonts=(
  # "ttf-jetbrains-mono-nerd:JetBrainsMono Nerd Font"
  "ttf-cascadia-code-nerd:CaskaydiaCove Nerd Font"
)

# Install all configured Nerd Fonts.
for font in "${fonts[@]}"; do
  omarchy pkg add "${font%%:*}"
done

# Set the last configured font as the system font.
omarchy font set "${fonts[-1]#*:}"