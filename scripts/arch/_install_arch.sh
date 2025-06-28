#!/usr/bin/env bash

set -e

# Prompt for setup type (workstation or server)
echo
read -p "Is this machine a workstation or a server? [w/s]: " setup_type
if [[ "$setup_type" =~ ^[Ww] ]]; then
  setup_type="workstation"
elif [[ "$setup_type" =~ ^[Ss] ]]; then
  setup_type="server"
else
  echo "Invalid input. Please enter 'w' for workstation or 's' for server."
  exit 1
fi
echo "🖥️ Arch Linux $setup_type Setup"

# Run appropriate Setup Script
if [[ "$setup_type" == "workstation" ]]; then
  $CHEZMOI_SOURCE_DIR/scripts/arch/install_arch_workstation.sh
else
  $CHEZMOI_SOURCE_DIR/scripts/arch/install_arch_server.sh
fi