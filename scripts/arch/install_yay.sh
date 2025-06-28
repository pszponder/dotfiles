#!/usr/bin/env bash

set -e

# Check if yay is already installed
if ! command -v yay &>/dev/null; then
  echo "Yay is not installed. Installing yay..."

  # Install necessary dependencies and yay
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  echo "Yay has been installed successfully."
else
  echo "Yay is already installed."
fi
