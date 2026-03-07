#!/usr/bin/env bash
set -euo pipefail

command_exists() { command -v "$1" >/dev/null 2>&1; }

if command_exists brew; then
  echo "✅ Homebrew is already installed."
  exit 0
fi

read -rp "❓ Do you want to install Homebrew? [y/N]: " response
case "$response" in
  [yY][eE][sS]|[yY]) ;;
  *)
    echo "❌ Skipping Homebrew installation."
    exit 0
    ;;
esac

# Install prerequisites on Linux
if [[ "$(uname -s)" == "Linux" ]]; then
  echo "🛠 Installing Homebrew prerequisites..."
  if command_exists apt-get; then
    sudo apt-get update
    sudo apt-get install -y build-essential procps curl file git
  elif command_exists dnf; then
    sudo dnf group install -y development-tools
    sudo dnf install -y procps-ng curl file git
  elif command_exists pacman; then
    sudo pacman -S --noconfirm --needed base-devel procps-ng curl file git
  else
    echo "⚠️ Could not install prerequisites: unsupported package manager."
  fi
fi

echo "🍺 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "✅ Homebrew installation complete."
