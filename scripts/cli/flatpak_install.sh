#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if [ "$(uname -s)" != "Linux" ]; then
  exit 0
fi

if command -v flatpak >/dev/null 2>&1; then
  log_info 'Flatpak already installed, skipping'
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get install -y flatpak
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --noconfirm --needed flatpak
else
  log_error 'No supported package manager found (apt, pacman)'
  exit 1
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
log_success 'Flathub remote configured'
