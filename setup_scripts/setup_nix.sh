#!/usr/bin/env bash

# =============================================
# Install Nix (https://nixos.org/download)
# Nix is useful for installing cli tools & apps
# https://christitus.com/nix-package-manager/
#==============================================
echo "Installing Nix Package Manager..."
sh <(curl -L https://nixos.org/nix/install) --daemon

echo "Sourcing Nix Package Manager..."
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# - make sure your computer doesn't already have Nix files (if it does, I will tell you how to clean them up.)
# - create local users (see the list above for the users I'll make)
# - create a local group (nixbld)
# - install Nix in to /nix
# - create a configuration file in /etc/nix
# - set up the "default profile" by creating some Nix-related files in /root
# - back up /etc/bashrc to /etc/bashrc.backup-before-nix
# - update /etc/bashrc to include some Nix configuration
# - back up /etc/profile.d/nix.sh to /etc/profile.d/nix.sh.backup-before-nix
# - update /etc/profile.d/nix.sh to include some Nix configuration
# - back up /etc/zshrc to /etc/zshrc.backup-before-nix
# - update /etc/zshrc to include some Nix configuration
# - back up /etc/bash.bashrc to /etc/bash.bashrc.backup-before-nix
# - update /etc/bash.bashrc to include some Nix configuration
# - load and start a service (at /etc/systemd/system/nix-daemon.service and /etc/systemd/system/nix-daemon.socket) for nix-daemon

# ==========================
# Install Packages using Nix
# ==========================
source nix_plugins-plugins.sh