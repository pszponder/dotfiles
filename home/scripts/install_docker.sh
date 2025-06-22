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

print_status "$BLUE" "🔍 Detected distribution: $DISTRO_ID"

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
