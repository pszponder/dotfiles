#!/bin/sh
set -eu

if [ "$(uname -s)" != "Linux" ]; then
  exit 0
fi

if command -v flatpak >/dev/null 2>&1; then
  printf '%s\n' 'Flatpak already installed, skipping'
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get install -y flatpak
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --noconfirm --needed flatpak
else
  printf '%s\n' 'No supported package manager found (apt, pacman)' >&2
  exit 1
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
printf '%s\n' 'Flathub remote configured'
