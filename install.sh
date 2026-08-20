#!/bin/sh
# Non-interactive entry point for environments that support dotfiles
# repositories. For interactive setup, use `chezmoi init --apply` directly.
#
# Usage: sh install.sh
set -eu

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Derive git identity from the container's forwarded credentials if available.
# Fall back to placeholders so chezmoi never blocks on an interactive prompt.
: "${GIT_NAME:=$(git config --global user.name 2>/dev/null || echo "Dev User")}"
: "${GIT_EMAIL:=$(git config --global user.email 2>/dev/null || echo "dev@example.com")}"
export GIT_NAME GIT_EMAIL

if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

chezmoi init --apply --source "$REPO_ROOT"
