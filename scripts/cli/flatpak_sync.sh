#!/bin/sh
set -eu

if [ "$(uname -s)" != "Linux" ]; then
  exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
  printf '%s\n' 'Flatpak not available; run just flatpak-install first' >&2
  exit 1
fi

MANIFEST="$HOME/.config/flatpak/packages"
if [ ! -f "$MANIFEST" ]; then
  printf '%s\n' "$MANIFEST not found; run chezmoi apply first" >&2
  exit 1
fi

while IFS= read -r app_id || [ -n "$app_id" ]; do
  case "$app_id" in
    ''|'#'*) continue ;;
  esac
  flatpak install --user --noninteractive flathub "$app_id"
done < "$MANIFEST"
