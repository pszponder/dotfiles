#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if [ "$(uname -s)" != "Linux" ]; then
  exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
  log_error 'Flatpak not available; run just flatpak-install first'
  exit 1
fi

MANIFEST="$HOME/.config/flatpak/packages"
if [ ! -f "$MANIFEST" ]; then
  log_error "$MANIFEST not found; run chezmoi apply first"
  exit 1
fi

while IFS= read -r app_id || [ -n "$app_id" ]; do
  case "$app_id" in
    ''|'#'*) continue ;;
  esac
  flatpak install --user --noninteractive flathub "$app_id"
done < "$MANIFEST"
