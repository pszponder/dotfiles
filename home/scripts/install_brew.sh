#!/usr/bin/env bash
set -euo pipefail

# Function to detect the OS
detect_os() {
  uname
}

# Function to detect the Linux distribution
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

# Function to install required dependencies based on Linux distro
install_dependencies() {
  local distro="$1"

  echo "📦 Installing required dependencies for $distro..."

  case "$distro" in
    ubuntu | debian)
      sudo apt update && sudo apt upgrade -y
      sudo apt install -y build-essential procps curl file git
      ;;
    fedora | rhel | centos)
      sudo dnf upgrade --refresh -y
      sudo dnf groupinstall -y 'Development Tools'
      sudo dnf install -y procps-ng curl file git
      ;;
    arch | manjaro)
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm base-devel procps-ng curl file git
      ;;
    *)
      echo "⚠️ Unknown or unsupported Linux distro. Skipping dependency installation."
      ;;
  esac
}

# Function to install Homebrew
install_homebrew() {
  echo "🍺 Homebrew not found. Installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Function to update and upgrade Homebrew packages
update_homebrew() {
  echo "🔄 Updating Homebrew and upgrading installed packages..."
  brew update
  brew upgrade
  echo "✅ Homebrew and packages updated. Exiting."
}

# Function to verify Homebrew installation
verify_homebrew() {
  echo "🧪 Verifying Homebrew installation..."
  brew --version
}

# Main function to orchestrate the setup
main() {
  echo "🔧 Starting Homebrew setup..."

  local os
  os="$(detect_os)"
  echo "🖥️ Detected OS: $os"

  if command -v brew &> /dev/null; then
    update_homebrew
    exit 0
  fi

  if [[ "$os" == "Linux" ]]; then
    local distro
    distro="$(detect_distro)"
    echo "🐧 Detected Linux distro: $distro"

    install_dependencies "$distro"
  fi

  install_homebrew
  verify_homebrew

  echo "🎉 Homebrew setup complete!"
}

# Execute the main function
main
