#!/usr/bin/env bash
set -euo pipefail

# Usage: install_packages_mise.sh
# Bootstraps mise if missing, then runs `mise install`.

command_exists() { command -v "$1" >/dev/null 2>&1; }

# Locate mise: check PATH first, then known install locations
mise_cmd=""
if command_exists mise; then
  mise_cmd="mise"
elif [[ -x "$HOME/.local/bin/mise" ]]; then
  mise_cmd="$HOME/.local/bin/mise"
elif [[ -x "$HOME/.mise/bin/mise" ]]; then
  mise_cmd="$HOME/.mise/bin/mise"
fi

# Bootstrap mise if not found anywhere
if [[ -z "$mise_cmd" ]]; then
  echo "🛠 Installing mise..."
  if curl -fsSL https://mise.run | sh; then
    echo "✅ mise installed"
    if [[ -x "$HOME/.local/bin/mise" ]]; then
      mise_cmd="$HOME/.local/bin/mise"
    elif [[ -x "$HOME/.mise/bin/mise" ]]; then
      mise_cmd="$HOME/.mise/bin/mise"
    else
      echo "⚠️ mise installed but binary not found"
    fi
  else
    echo "⚠️ Failed to install mise, skipping."
    exit 0
  fi
fi

if [[ -n "$mise_cmd" ]]; then
  echo "🔧 Running mise install..."
  "$mise_cmd" install || echo "⚠️ mise install failed"
else
  echo "⚠️ Skipping mise install (binary unavailable)"
fi

echo "✅ mise tool installation complete."
