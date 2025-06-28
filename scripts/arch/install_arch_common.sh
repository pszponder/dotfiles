#!/usr/bin/env bash

set -e

echo "🔧 Running common Arch setup (server/workstation)"

# Update system first
sudo pacman -Syu --noconfirm

# Install paru (and its dependencies)
# "$(dirname "$0")/install_paru.sh"

# Install yay (and its dependencies)
"$(dirname "$0")/install_yay.sh"

# Install fonts
"$(dirname "$0")/install_fonts.sh"

# Add more common setup steps here, e.g.:
# sudo pacman -S --needed --noconfirm <common-package>
