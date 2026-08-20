#!/bin/sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
LINK_PATH="$HOME/repos/github/pszponder/dotfiles"

if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
  printf '%s\n' "Skipping existing path: $LINK_PATH"
  exit 0
fi

ln -s "$REPO_ROOT" "$LINK_PATH"
printf '%s\n' "Linked $LINK_PATH -> $REPO_ROOT"