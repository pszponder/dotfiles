#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

MISE_BIN=$(command -v mise 2>/dev/null || true)
if [ -z "$MISE_BIN" ] && [ -x "$HOME/.local/bin/mise" ]; then
  MISE_BIN="$HOME/.local/bin/mise"
fi

for mise_path in /opt/homebrew/bin/mise /home/linuxbrew/.linuxbrew/bin/mise; do
  if [ -z "$MISE_BIN" ] && [ -x "$mise_path" ]; then
    MISE_BIN="$mise_path"
  fi
done

if [ -z "$MISE_BIN" ]; then
  log_error 'mise not available; run just mise-install first'
  exit 1
fi

MISE_CONFIG="$HOME/.config/mise/config.toml"
if [ ! -f "$MISE_CONFIG" ]; then
  log_error 'mise config not found; run chezmoi apply first'
  exit 1
fi

"$MISE_BIN" trust "$MISE_CONFIG"

BREW_BIN=$(command -v brew 2>/dev/null || true)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -z "$BREW_BIN" ] && [ -x "$brew_path" ]; then
    BREW_BIN="$brew_path"
  fi
done

# Homebrew owns the shared CLI tools in config.no-brew.toml; only load that
# file (via MISE_ENV) when Homebrew isn't installed, so mise install picks
# up just the runtimes in config.toml when Homebrew is present.
NO_BREW_CONFIG="$HOME/.config/mise/config.no-brew.toml"
if [ -z "$BREW_BIN" ] && [ -f "$NO_BREW_CONFIG" ]; then
  export MISE_ENV=no-brew
  "$MISE_BIN" trust "$NO_BREW_CONFIG"
fi

"$MISE_BIN" install
"$MISE_BIN" reshim
