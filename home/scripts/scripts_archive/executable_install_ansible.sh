#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Path to your install_brew.sh script
INSTALL_BREW_SCRIPT="./install_brew.sh"

# Function to check if Homebrew is installed
# Returns 0 (true) if installed, 1 (false) if not installed
check_homebrew() {
  if command -v brew &>/dev/null; then
    return 0  # Homebrew is installed
  else
    return 1  # Homebrew is NOT installed
  fi
}

# Function to install Homebrew using install_brew.sh
install_homebrew() {
  echo "🍺 Homebrew is not installed! Attempting to install it..."
  if [[ -f "$INSTALL_BREW_SCRIPT" ]]; then
    echo "📜 Found install_brew.sh, running it now..."
    bash "$INSTALL_BREW_SCRIPT"
    echo "✅ Homebrew installation complete!"
  else
    echo "❌ install_brew.sh not found! Please install Homebrew manually."
    exit 1
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

  # Check if Homebrew is installed
  if check_homebrew; then
    echo "🍻 Homebrew is already installed. Proceeding!"
  else
    install_homebrew
  fi

  install_ansible
}

# Call the main function
main
