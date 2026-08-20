#!/bin/sh
set -eu

BREW_BIN=$(command -v brew 2>/dev/null || true)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -z "$BREW_BIN" ] && [ -x "$brew_path" ]; then
    BREW_BIN="$brew_path"
  fi
done

if [ -z "$BREW_BIN" ]; then
  printf '%s\n' 'Homebrew not available; run just brew-install first' >&2
  exit 1
fi

BREWFILE="$HOME/.config/homebrew/Brewfile"
if [ ! -f "$BREWFILE" ]; then
  printf '%s\n' "$BREWFILE not found; run chezmoi apply first" >&2
  exit 1
fi

"$BREW_BIN" bundle --file="$BREWFILE" --jobs=auto
