#!/usr/bin/env bash

set -e

# TODO: Update the list of apps to install (refer to executable_install_flatpak_apps.sh)

# List of Flatpak apps to install (edit as needed)
FLATPAK_APPS=(
  com.github.tchx84.Flatseal
  io.podman_desktop.PodmanDesktop
)

echo "📦 Checking for flatpak..."
if ! command -v flatpak &>/dev/null; then
  echo "🔧 Installing flatpak..."
  sudo pacman -S --noconfirm --needed flatpak
else
  echo "✅ flatpak is already installed."
fi

echo "🌐 Configuring Flathub repository..."
if ! flatpak remote-list | grep -q flathub; then
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
  echo "✅ Flathub is already configured."
fi

echo "📦 Installing Flatpak apps: ${FLATPAK_APPS[*]}"
for app in "${FLATPAK_APPS[@]}"; do
  if flatpak list --app | grep -q "${app}"; then
    echo "✅ $app is already installed."
  else
    flatpak install -y flathub "$app"
  fi
done

echo "🎉 Flatpak setup and app installation complete."
