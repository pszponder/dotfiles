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
  log_info 'Homebrew is not installed, skipping'
  exit 0
fi

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
log_success 'Homebrew uninstalled'