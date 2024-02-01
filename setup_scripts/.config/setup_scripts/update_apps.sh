#!/usr/bin/env bash

# Update Nix Packages
echo "Updating Nix Packages..."
nix-env -u

# Update Flatpak Packages
echo "Updating Flatpak Packages..."
flatpak update

# Update Snap Packages
echo "Updating Snap Packages..."
snap refresh

# Updating Programming Languages (via mise)
echo "Updating Programming Languages..."
mise upgrade