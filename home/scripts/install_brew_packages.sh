#!/usr/bin/env bash

# Exit immediately on error
set -e

# Define an array of brew packages to install (CLI tools)
BREW_PACKAGES=(
  atuin
  bat
  bottom
  delta
  direnv
  eza
  fd
  fish
  fzf
  gh
  jq
  just
  lazydocker
  lazygit
  make
  mise
  neovim
  nushell
  ollama
  ripgrep
  starship
  tmux
  tealdeer
  trash-cli
  yazi
  zellij
  zoxide
  zsh
)

# Define an array of casks to install (macOS GUI apps)
BREW_CASKS=(
  brave-browser
  discord
  docker
  ghostty
  google-chrome
  raycast         # Spotlight alternative
  rectangle       # Window manager
  lm-studio
  podman-desktop
  postman
  visual-studio-code
  zed
)

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to check if a brew package is already installed
brew_package_installed() {
  brew list --formula "$1" &> /dev/null
}

# Function to check if a cask is already installed
brew_cask_installed() {
  brew list --cask "$1" &> /dev/null
}

# Check if Homebrew is installed
if ! command_exists brew; then
  echo "❌ Homebrew is not installed. Please run the install_brew.sh script first."
  exit 1
fi

echo "🔄 Updating Homebrew..."
brew update

echo "📦 Installing Homebrew packages..."
for package in "${BREW_PACKAGES[@]}"; do
  if [[ "$package" == \#* ]] || [[ -z "$package" ]]; then
    continue
  fi

  if brew_package_installed "$package"; then
    echo "✅ $package is already installed, skipping..."
  else
    echo "📥 Installing $package..."
    brew install "$package"
  fi
done

# Check for macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍏 macOS detected — installing Homebrew casks..."
  for cask in "${BREW_CASKS[@]}"; do
    if [[ "$cask" == \#* ]] || [[ -z "$cask" ]]; then
      continue
    fi

    if brew_cask_installed "$cask"; then
      echo "✅ $cask is already installed, skipping..."
    else
      echo "📥 Installing cask: $cask..."
      brew install --cask "$cask"
    fi
  done
fi

echo "🎉 Homebrew installation complete!"

echo ""
echo "📝 Customize the BREW_PACKAGES and BREW_CASKS arrays to your liking."
echo "   Current script: $(readlink -f "$0" 2>/dev/null || realpath "$0")"
