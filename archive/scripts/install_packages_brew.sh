#!/usr/bin/env bash
set -euo pipefail

# Usage: install_packages_brew.sh
# Installs Homebrew packages from the global Brewfile (~/.Brewfile).

command_exists() { command -v "$1" >/dev/null 2>&1; }

if ! command_exists brew; then
  echo "⏭ Homebrew is not installed, skipping Brewfile."
  exit 0
fi

if [[ ! -f "$HOME/.Brewfile" ]]; then
  echo "⚠️ No ~/.Brewfile found, skipping."
  exit 0
fi

echo "🍺 Installing Homebrew packages from Brewfile..."
brew bundle --global --no-lock

echo "✅ Homebrew package installation complete."