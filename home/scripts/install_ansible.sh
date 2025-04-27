#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Path to your install_brew.sh script
INSTALL_BREW_SCRIPT="./install_brew.sh"

# Function to check if Homebrew is installed
check_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "🍺 Homebrew is not installed! Attempting to install it..."
    if [[ -f "$INSTALL_BREW_SCRIPT" ]]; then
      echo "📜 Found install_brew.sh, running it now..."
      bash "$INSTALL_BREW_SCRIPT"
      echo "✅ Homebrew installation complete!"
    else
      echo "❌ install_brew.sh not found! Please install Homebrew manually."
      exit 1
    fi
  else
    echo "🍻 Homebrew is already installed. Proceeding!"
  fi
}

# Function to install Ansible
install_ansible() {
  echo "🔄 Updating Homebrew..."
  brew update

  echo "🔍 Checking if Ansible is already installed..."
  if brew list ansible &>/dev/null; then
    echo "✅ Ansible is already installed! Skipping installation."
  else
    echo "🚀 Installing Ansible..."
    brew install ansible
    echo "🎉 Ansible installation complete!"
  fi
}

# Main function
main() {
  echo "🏗️ Starting Ansible installation script..."
  check_homebrew
  install_ansible
}

# Call the main function
main
