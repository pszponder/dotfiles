#!/usr/bin/env bash
set -euo pipefail

command_exists() { command -v "$1" >/dev/null 2>&1; }

if command_exists flatpak; then
  echo "✅ Flatpak is already installed."
  exit 0
fi

read -rp "❓ Do you want to install Flatpak support? [y/N]: " response
case "$response" in
  [yY][eE][sS]|[yY]) ;;
  *)
    echo "❌ Skipping Flatpak installation."
    exit 0
    ;;
esac

echo "📦 Installing Flatpak..."

if command_exists apt-get; then
  sudo apt-get update
  sudo apt-get install -y flatpak
elif command_exists dnf; then
  sudo dnf install -y flatpak
elif command_exists pacman; then
  sudo pacman -S --noconfirm --needed flatpak
else
  echo "⚠️ Unsupported system: no supported package manager found."
  exit 1
fi

echo "🔗 Adding Flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "✅ Flatpak installation complete."
