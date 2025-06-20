#!/usr/bin/env bash

set -euo pipefail

echo "🔄 Starting system update..."

# 🐧 Detect and update system packages
if command -v apt &>/dev/null; then
  echo "📦 Updating APT packages..."
  sudo apt update && sudo apt upgrade -y
elif command -v dnf &>/dev/null; then
  echo "📦 Updating DNF packages..."
  sudo dnf upgrade --refresh -y
elif command -v pacman &>/dev/null; then
  echo "📦 Updating Pacman packages..."
  sudo pacman -Syu --noconfirm
else
  echo "⚠️  Unknown package manager. Skipping system update."
fi

# 🍺 Update Homebrew packages
if command -v brew &>/dev/null; then
  echo "🍺 Updating Homebrew..."
  brew update
  brew upgrade
  brew cleanup
else
  echo "⚠️  Homebrew not found."
fi

# 🧩 Update Flatpak apps
if command -v flatpak &>/dev/null; then
  echo "🧩 Updating Flatpak packages..."
  flatpak update -y
else
  echo "⚠️  Flatpak not found."
fi

# 🛠️ Update mise and tools
if command -v mise &>/dev/null; then
  echo "🛠️ Updating mise..."
  mise self-update

  echo "📦 Updating mise installed tools..."
  mise upgrade
else
  echo "⚠️  mise not found."
fi

echo "✅ Update complete!"
