#!/usr/bin/env bash
set -euo pipefail

command_exists() { command -v "$1" >/dev/null 2>&1; }

if command_exists google-chrome-stable; then
  echo "✅ Google Chrome is already installed."
  exit 0
fi

read -rp "❓ Do you want to install Google Chrome? [y/N]: " response
case "$response" in
  [yY][eE][sS]|[yY]) ;;
  *)
    echo "❌ Skipping Google Chrome installation."
    exit 0
    ;;
esac

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

if command_exists apt-get; then
  echo "📦 Installing Google Chrome (APT-based Linux)..."
  wget -q -O "$tmpdir/google-chrome-stable.deb" \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt-get install -y "$tmpdir/google-chrome-stable.deb"
elif command_exists dnf; then
  echo "📦 Installing Google Chrome (DNF-based Linux)..."
  wget -q -O "$tmpdir/google-chrome-stable.rpm" \
    https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
  sudo dnf localinstall -y "$tmpdir/google-chrome-stable.rpm"
else
  echo "⚠️ Unsupported system: no supported package manager found."
  exit 1
fi

echo "✅ Google Chrome installation complete."
