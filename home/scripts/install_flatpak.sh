#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔄 Starting Flatpak installation process..."

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Check if Flatpak is already installed
if command_exists flatpak; then
  echo "✅ Flatpak is already installed."
  flatpak --version
  exit 0
fi

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  echo "❌ Cannot detect Linux distribution. Please install Flatpak manually."
  exit 1
fi

echo "🐧 Detected Linux distribution: $DISTRO"

# Install flatpak based on the detected distribution
case $DISTRO in
  ubuntu|debian|pop)
    echo "📦 Installing Flatpak for Ubuntu/Debian..."
    sudo apt update
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    ;;
  fedora)
    echo "📦 Installing Flatpak for Fedora..."
    sudo dnf install -y flatpak
    ;;
  centos|rhel)
    echo "📦 Installing Flatpak for CentOS/RHEL..."
    sudo yum install -y flatpak
    ;;
  arch|manjaro)
    echo "📦 Installing Flatpak for Arch/Manjaro..."
    sudo pacman -S --noconfirm flatpak
    ;;
  *)
    echo "❌ Unsupported distribution: $DISTRO. Please install Flatpak manually."
    exit 1
    ;;
esac

# Add Flathub repository
echo "🔄 Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "✅ Flatpak installation completed successfully."
echo "Flatpak version: $(flatpak --version)"
echo "Available remotes: "
flatpak remotes

# Inform the user about the need to log out
echo "🔔 NOTE: You may need to log out and back in for Flatpak to work properly."
