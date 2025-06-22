#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
  local color="$1"
  local message="$2"
  echo -e "${color}${message}${NC}"
}

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
  print_status "$RED" "❌ Do not run this script as root. It uses sudo internally."
  exit 1
fi

# Detect distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO_ID="$ID"
else
  print_status "$RED" "❌ Cannot detect Linux distribution. /etc/os-release not found."
  exit 1
fi

print_status "$BLUE" "🔍 Detected distribution: $DISTRO_ID"

# Install curl if needed
if ! command -v curl &>/dev/null; then
  print_status "$YELLOW" "📦 Installing curl..."
  case "$DISTRO_ID" in
    ubuntu|debian)
      sudo apt-get update && sudo apt-get install -y curl
      ;;
    fedora)
      sudo dnf install -y curl
      ;;
    centos|rhel|rocky|almalinux)
      sudo yum install -y curl
      ;;
    opensuse*|sles)
      sudo zypper install -y curl
      ;;
    arch)
      sudo pacman -Sy --noconfirm curl
      ;;
    *)
      print_status "$YELLOW" "⚠️  Unknown distro: $DISTRO_ID. Attempting to install curl anyway..."
      sudo apt-get update && sudo apt-get install -y curl || \
      sudo dnf install -y curl || \
      sudo yum install -y curl || \
      sudo zypper install -y curl || \
      sudo pacman -Sy --noconfirm curl || \
      print_status "$RED" "❌ Failed to install curl. Aborting."
      exit 1
      ;;
  esac
fi

print_status "$BLUE" "🐳 Downloading Docker's official convenience script..."
curl -fsSL https://get.docker.com -o get-docker.sh

print_status "$BLUE" "🔧 Running Docker installation script..."
sudo sh get-docker.sh

print_status "$GREEN" "✅ Docker Engine installation completed."

print_status "$BLUE" "👤 Adding current user to the docker group..."
sudo usermod -aG docker "$USER"

print_status "$YELLOW" "🔁 Please log out and back in (or run 'newgrp docker') to apply group changes."

# Cleanup
rm -f get-docker.sh
