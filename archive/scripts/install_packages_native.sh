#!/usr/bin/env bash
set -euo pipefail

# Usage: install_packages_native.sh <linux_family> <package> [package ...]
# Installs native packages using the appropriate package manager for the distro family.

command_exists() { command -v "$1" >/dev/null 2>&1; }

LINUX_FAMILY="${1:-}"
shift || true
packages=("$@")

if [[ -z "$LINUX_FAMILY" ]]; then
  echo "⚠️ No Linux family specified, skipping native packages."
  exit 0
fi

if [[ "${#packages[@]}" -eq 0 ]]; then
  echo "⚠️ No packages to install, skipping."
  exit 0
fi

echo "📦 Installing native packages: ${packages[*]}"

case "$LINUX_FAMILY" in
  ubuntu|debian)
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
    ;;
  fedora)
    if command_exists rpm-ostree; then
      echo "📦 Immutable Fedora detected, using rpm-ostree..."
      rpm-ostree install --idempotent --allow-inactive "${packages[@]}"
      echo "⚠️ A reboot may be required for layered packages to take effect."
    else
      sudo dnf install -y "${packages[@]}"
    fi
    ;;
  arch)
    # bootstrap paru if missing
    if ! command_exists paru; then
      echo "🛠 paru not found – bootstrapping from AUR..."
      sudo pacman -S --noconfirm --needed git base-devel
      tmpdir=$(mktemp -d)
      git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
      pushd "$tmpdir/paru" >/dev/null
      makepkg -si --noconfirm
      popd >/dev/null
      rm -rf "$tmpdir"
    fi
    echo "📦 Installing packages with paru..."
    paru -Syu --needed --noconfirm "${packages[@]}"
    ;;
  *)
    echo "⚠️ Unsupported Linux family: $LINUX_FAMILY"
    exit 1
    ;;
esac

echo "✅ Native package installation complete."