#!/usr/bin/env bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "⚙️ Configuring GNOME settings..."

if command -v gsettings &>/dev/null; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
#   gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
  gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
  gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
  gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
  gsettings set org.gnome.desktop.background picture-uri-dark "file://${SCRIPT_DIR}/wallpapers/catppuccin.png"
  gsettings set org.gnome.desktop.background picture-options 'scaled'
  echo "✅ GNOME settings applied."
else
  echo "⚠️ gsettings not found. Please configure GNOME settings manually."
fi