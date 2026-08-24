#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if [ "$(uname -s)" != "Linux" ]; then
  exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
  log_info 'Flatpak is not installed, skipping'
  exit 0
fi

flatpak uninstall --all --delete-data -y
flatpak remote-delete flathub 2>/dev/null || true

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get remove -y flatpak
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Rns --noconfirm flatpak
else
  log_error 'Flatpak applications removed, but no supported package manager was found to remove Flatpak'
  exit 1
fi

log_success 'Flatpak uninstalled'