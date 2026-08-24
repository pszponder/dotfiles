#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

BREW_BIN=$(command -v brew 2>/dev/null || true)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -z "$BREW_BIN" ] && [ -x "$brew_path" ]; then
    BREW_BIN="$brew_path"
  fi
done

if [ -z "$BREW_BIN" ]; then
  log_error 'Homebrew not available; run just brew-install first'
  exit 1
fi

BREWFILE="$HOME/.config/homebrew/Brewfile"
if [ ! -f "$BREWFILE" ]; then
  log_error "$BREWFILE not found; run chezmoi apply first"
  exit 1
fi

"$BREW_BIN" bundle --file="$BREWFILE" --jobs=auto
