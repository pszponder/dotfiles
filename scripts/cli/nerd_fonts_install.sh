#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if command -v brew >/dev/null 2>&1 || [ -x /opt/homebrew/bin/brew ] || [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  log_info 'Homebrew detected; Nerd Fonts are managed by the Brewfile, skipping'
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  log_error 'curl is required to install Nerd Fonts'
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  log_error 'tar with XZ support is required to install Nerd Fonts'
  exit 1
fi

case "$(uname -s)" in
  Darwin) FONT_DIR="$HOME/Library/Fonts" ;;
  Linux) FONT_DIR="$HOME/.local/share/fonts" ;;
  *)
    log_error 'Nerd Fonts installation is supported only on macOS and Linux'
    exit 1
    ;;
esac

MANIFEST="$HOME/.config/nerd-fonts/fonts"
if [ ! -f "$MANIFEST" ]; then
  log_error "$MANIFEST not found; run chezmoi apply first"
  exit 1
fi

mkdir -p "$FONT_DIR"
temporary_dir=$(mktemp -d)
trap 'rm -rf "$temporary_dir"' EXIT HUP INT TERM

while IFS= read -r font_name || [ -n "$font_name" ]; do
  case "$font_name" in
    ''|'#'*) continue ;;
  esac

  archive="$temporary_dir/$font_name.tar.xz"
  curl --fail --location --output "$archive" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.tar.xz"
  tar -xJf "$archive" -C "$FONT_DIR"
done < "$MANIFEST"

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$FONT_DIR"
fi
