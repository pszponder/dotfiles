#!/bin/sh
set -eu

remote="$(chezmoi git -- remote get-url origin 2>/dev/null || true)"

case "$remote" in
  https://github.com/pszponder/dotfiles.git)
    chezmoi git -- remote set-url origin \
      git@github.com:pszponder/dotfiles.git
    ;;
esac
