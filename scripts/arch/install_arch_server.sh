#!/usr/bin/env bash

set -e

echo "🖥️ Arch Linux Server Setup"

# Run common setup (paru, etc.)
"$(dirname "$0")/install_arch_common.sh"

# Source package groups
source "$(dirname "$0")/arch_packages.conf"

# Choose which groups to install for server
for group in SYSTEM_UTILS CLI_TOOLS FONTS; do
  pkg_array_name="$group[@]"
  pkg_list=("${!pkg_array_name}")
  pkgs_to_install=()
  for pkg in "${pkg_list[@]}"; do
    if ! paru -Qq "$pkg" &>/dev/null; then
      pkgs_to_install+=("$pkg")
    else
      echo "✅ $pkg is already installed."
    fi
  done
  if [[ ${#pkgs_to_install[@]} -gt 0 ]]; then
    echo "📦 Installing $group: ${pkgs_to_install[*]}"
    paru -S --noconfirm --needed "${pkgs_to_install[@]}"
  fi
  echo
done

# Enable and start services
if [[ ${#SERVICES[@]} -gt 0 ]]; then
  echo "🔧 Enabling and starting services: ${SERVICES[*]}"
  for svc in "${SERVICES[@]}"; do
    if ! systemctl is-enabled "$svc" &>/dev/null; then
      echo "Enabling $svc..."
      sudo systemctl enable --now "$svc"
    else
      echo "$svc is already enabled"
    fi
  done
fi

echo "🎉 Arch server setup complete!"
