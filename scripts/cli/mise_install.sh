#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if command -v mise >/dev/null 2>&1; then
  log_info 'mise already available in PATH, skipping'
  exit 0
fi

BREW_BIN=$(command -v brew 2>/dev/null || true)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -z "$BREW_BIN" ] && [ -x "$brew_path" ]; then
    BREW_BIN="$brew_path"
  fi
done

if [ -n "$BREW_BIN" ]; then
  "$BREW_BIN" install mise
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  log_error 'curl is required to install mise when Homebrew is unavailable'
  exit 1
fi

curl -fsSL https://mise.run | sh

if [ ! -x "$HOME/.local/bin/mise" ]; then
  log_error "mise installer completed but $HOME/.local/bin/mise was not found"
  exit 1
fi
