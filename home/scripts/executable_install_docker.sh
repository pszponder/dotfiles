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

# Function to check if Docker is installed
is_docker_installed() {
    # Check if the 'docker' command exists in the system's PATH
    command -v docker &> /dev/null
}

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
  print_status "$RED" "❌ Do not run this script as root. It uses sudo internally."
  exit 1
fi

if is_docker_installed; then
    print_status "$YELLOW" "⚠️ Docker appears to be already installed."
    read -p "$(echo -e "${YELLOW}Do you want to proceed with re-installation/update? (y/N): ${NC}")" confirm_continue
    confirm_continue=${confirm_continue,,} # Convert to lowercase

    if [[ "$confirm_continue" != "y" ]]; then
        print_status "$BLUE" "ℹ️ Aborting Docker installation as requested."
        exit 0
    else
        print_status "$BLUE" "🔄 Proceeding with Docker installation/update..."
    fi
fi

print_status "$BLUE" "🐳 Downloading Docker's official convenience script..."
curl -fsSL https://get.docker.com -o get-docker.sh

print_status "$BLUE" "🔧 Running Docker installation script..."
# The Docker convenience script needs to be executable by sh
# And it often includes sudo commands internally, so we use sudo sh.
sudo sh get-docker.sh

print_status "$GREEN" "✅ Docker Engine installation completed."

print_status "$BLUE" "👤 Adding current user to the docker group..."
# Check if the group exists, if not, it will be created by the get-docker.sh script
# We can safely add the user here, even if the group was just created.
sudo usermod -aG docker "$USER"

print_status "$YELLOW" "🔁 Please log out and back in (or run 'newgrp docker') to apply group changes."
print_status "$YELLOW" "   You may also need to restart your terminal for group changes to take effect."

# Cleanup
rm -f get-docker.sh