#!/usr/bin/env bash
set -euo pipefail

# Usage: install_packages_flatpak.sh <app_id> [app_id ...]
# Installs Flatpak apps from Flathub.

command_exists() { command -v "$1" >/dev/null 2>&1; }

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "⏭ Skipping Flatpak apps (Linux only)."
  exit 0
fi

if ! command_exists flatpak; then
  echo "⚠️ Flatpak is not installed, skipping Flatpak apps."
  exit 0
fi

flatpaks=("$@")

if [[ "${#flatpaks[@]}" -eq 0 ]]; then
  echo "⚠️ No Flatpak apps to install, skipping."
  exit 0
fi

echo "📦 Installing Flatpak apps..."

failed_apps=()

for app in "${flatpaks[@]}"; do
  echo "  → $app"
  if ! flatpak install --system -y --noninteractive flathub "$app"; then
    echo "    ⚠️ Failed"
    failed_apps+=("$app")
  fi
done

if [[ ${#failed_apps[@]} -gt 0 ]]; then
  echo "⚠️ Some Flatpak apps failed:"
  printf '  - %s\n' "${failed_apps[@]}"
fi

echo "✅ Flatpak installation complete."