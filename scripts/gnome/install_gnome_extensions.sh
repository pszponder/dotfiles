#!/usr/bin/env bash

set -e

# List of GNOME extension UUIDs to install
# Find UUIDs at https://extensions.gnome.org
GNOME_EXTENSIONS=(
  "tactile@lundal.io"
  "just-perfection-desktop@just-perfection"
  "blur-my-shell@aunetx"
  "space-bar@luchrioh"
  "undecorate@sun.wxg@gmail.com"
  "tophat@fflewddur.github.io"
  "switcher@landau.fi"
)

# Ensure pipx is installed
if ! command -v pipx &>/dev/null; then
  echo "🔧 Installing pipx..."
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
fi

# Ensure gext (gnome-extensions-cli) is installed via pipx
if ! ~/.local/bin/gext --version &>/dev/null; then
  echo "🔧 Installing gext (gnome-extensions-cli) via pipx..."
  pipx install gnome-extensions-cli --system-site-packages
fi

export PATH="$HOME/.local/bin:$PATH"

echo "🧩 Installing GNOME extensions with gext..."
for ext in "${GNOME_EXTENSIONS[@]}"; do
  if ! gext list | grep -q "$ext"; then
    echo "🌐 Installing GNOME extension: $ext"
    gext install "$ext" --yes --force
    gext enable "$ext"
  else
    echo "✅ Extension already installed: $ext"
  fi
done

echo "✅ GNOME extensions installation complete."
