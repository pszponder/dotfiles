#!/usr/bin/env bash

set -e

echo "🔧 Checking for paru..."

# Ensure base-devel and git are installed (required for building paru)
sudo pacman -Syu --needed --noconfirm base-devel git

# Install paru if not already installed
if ! command -v paru &>/dev/null; then
  echo "📦 paru not found, installing..."
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  pushd "$tmpdir/paru"
  makepkg -si --noconfirm
  popd
  rm -rf "$tmpdir"
else
  echo "✅ paru is already installed."
fi

# Update all packages
paru -Syu --noconfirm