#!/usr/bin/env bash
set -euo pipefail

# Colors for status messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
  local color="$1"
  local message="$2"
  echo -e "${color}${message}${NC}"
}

# Detect the OS platform
OS=$(uname -s)
ARCH=$(uname -m)

print_status "$YELLOW" "🔍 Detecting operating system: $OS"

# Function to install Podman on Linux (Debian/Ubuntu/Fedora/Arch)
install_podman_linux() {
  if command -v apt &>/dev/null; then
    print_status "$YELLOW" "📦 Installing Podman via apt..."
    sudo apt-get update
    sudo apt-get install -y podman
  elif command -v dnf &>/dev/null; then
    print_status "$YELLOW" "📦 Installing Podman via dnf..."
    sudo dnf -y install podman
  elif command -v pacman &>/dev/null; then
    print_status "$YELLOW" "📦 Installing Podman via pacman..."
    sudo pacman -Sy --noconfirm podman
  elif command -v zypper &>/dev/null; then
    print_status "$YELLOW" "📦 Installing Podman via zypper..."
    sudo zypper install -y podman
  else
    print_status "$RED" "❌ Unsupported Linux distribution. Please install Podman manually."
    exit 1
  fi
}

# Function to install Podman on macOS
install_podman_macos() {
  print_status "$YELLOW" "🍎 Detected macOS"
  print_status "$YELLOW" "📥 Downloading and installing Podman via official .pkg..."

  # Define version and URL
  PODMAN_PKG_URL="https://github.com/containers/podman/releases/latest/download/podman-installer-macos.pkg"
  TEMP_PKG="/tmp/podman.pkg"

  curl -L "$PODMAN_PKG_URL" -o "$TEMP_PKG"
  sudo installer -pkg "$TEMP_PKG" -target /
  rm "$TEMP_PKG"

  print_status "$GREEN" "✅ Podman installed via .pkg. Run 'podman machine init' to set up your environment."
}

# Main logic
case "$OS" in
  Linux)
    install_podman_linux
    ;;
  Darwin)
    install_podman_macos
    ;;
  *)
    print_status "$RED" "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

print_status "$GREEN" "🎉 Podman CLI installation complete!"
