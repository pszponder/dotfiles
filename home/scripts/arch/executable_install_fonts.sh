#!/usr/bin/env bash

set -e

echo "🔤 Installing Nerd Fonts and Noto Fonts..."

FONTS=(
  ttf-cascadia-code-nerd
  ttf-jetbrains-mono-nerd
  noto-fonts
  noto-fonts-emoji
  noto-fonts-extra
)

# Install all fonts with pacman (official repos)
echo "📦 Installing fonts via pacman: ${FONTS[*]}"
sudo pacman -S --noconfirm --needed "${FONTS[@]}"

echo "🗂 Updating font cache..."
fc-cache -fv

echo "✅ Selected Nerd Fonts and Noto Fonts installed successfully."
