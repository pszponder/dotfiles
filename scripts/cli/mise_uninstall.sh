#!/bin/sh
set -eu

BREW_BIN=$(command -v brew 2>/dev/null || true)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -z "$BREW_BIN" ] && [ -x "$brew_path" ]; then
    BREW_BIN="$brew_path"
  fi
done

if [ -n "$BREW_BIN" ] && "$BREW_BIN" list --formula mise >/dev/null 2>&1; then
  MISE_BIN=$("$BREW_BIN" --prefix mise)/bin/mise
  "$MISE_BIN" implode
  "$BREW_BIN" uninstall mise
fi

if [ -x "$HOME/.local/bin/mise" ]; then
  "$HOME/.local/bin/mise" implode
fi

printf '%s\n' 'mise uninstalled'