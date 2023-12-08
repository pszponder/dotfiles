#!/usr/bin/env bash

# ================================================
# Install Git (https://git-scm.com/download/linux)
# ================================================
echo "Installing Git..."
sudo apt-get install git

# Install / Setup Nix
./scripts/setup_nix.sh

# ==============================
# Configure ZSH + Starship + Zap
# ==============================
echo "Setting up ZSH..."
./scripts/setup_zsh.sh

# ===========================
# Installing Package Managers
# ===========================
echo "Installing Package Managers..."
./scripts/install_flatpak.sh
./scripts/install_snap.sh

# ====================
# Install Applications
# ====================
echo "Installing Applications..."
./scripts/install_apps.sh

# =================================================================
# Install Programming Languages w/ RTX (https://github.com/jdx/rtx)
# =================================================================
echo "Installing Programming Languages..."
./scripts/install_languages.sh

# ==============
# Setup Dotfiles
# ==============
echo "Installing GNU Stow..."
sudo apt install stow