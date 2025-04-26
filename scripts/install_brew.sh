#!/usr/bin/env bash

set -e  # Exit on error

echo "🔧 Starting Homebrew installation..."

# Detect OS and Distro
OS=$(uname)
echo "🖥️ Detected OS: $OS"

DISTRO="unknown"
if [[ "$OS" == "Linux" && -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=$ID
    echo "🐧 Detected Linux distro: $DISTRO"
fi

# Install dependencies based on distro
install_dependencies() {
    echo "📦 Installing required dependencies..."
    case "$DISTRO" in
        ubuntu | debian)
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y build-essential procps curl file git
            ;;
        fedora|rhel|centos)
            # Update system
            sudo dnf upgrade --refresh -y

            # Install Development Tools group and core utilities
            sudo dnf groupinstall -y 'Development Tools'      # compilers, make, etc.
            sudo dnf install -y procps-ng curl file git
            ;;
        arch | manjaro)
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm base-devel procps-ng curl file git
            ;;
        *)
            echo "⚠️ Unknown or unsupported Linux distro. Skipping dependency install."
            ;;
    esac
}

# Run dependency install for Linux
if [[ "$OS" == "Linux" ]]; then
    install_dependencies
fi

# Install Homebrew (only if not already installed)
if ! command -v brew &> /dev/null; then

    # Non-interactive Homebrew install
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

else
    echo "✅ Homebrew already installed."
fi

# Confirm installation
echo "🧪 Verifying Homebrew..."
brew --version

echo "🎉 Homebrew setup complete!"
