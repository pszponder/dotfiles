#!/usr/bin/env bash

set -e

REPO_DIR="$(dirname "$CHEZMOI_SOURCE_DIR")"
CURRENT_URL=$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || true)

# Only switch if current URL is HTTPS
if [[ "$CURRENT_URL" == https://github.com/* ]]; then
  # Convert https://github.com/user/repo.git -> git@github.com:user/repo.git
  SSH_URL="${CURRENT_URL/https:\/\/github.com\//git@github.com:}"
  echo "🔄 Switching chezmoi repo remote from HTTPS to SSH..."
  echo "   Old: $CURRENT_URL"
  echo "   New: $SSH_URL"
  git -C "$REPO_DIR" remote set-url origin "$SSH_URL"
  echo "✅ Remote URL switched to SSH."
else
  echo "ℹ️ Remote URL is already SSH or not GitHub, skipping."
fi
