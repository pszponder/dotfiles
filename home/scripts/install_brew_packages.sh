#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define an array of brew packages to install
BREW_PACKAGES=(
  atuin        # Better shell history
  bat          # Better cat with syntax highlighting
  bottom       # Resource viewer
  delta        # Better git diff
  direnv       # Load/unload environmental variables
  eza          # Modern ls replacement
  fd           # Fast find replacement
  fish         # Fish shell
  fzf          # Fuzzy finder
  gh           # GitHub CLI
  jq           # JSON processor
  just         # Rust-based alternative to make
  lazydocker   # TUI for docker
  lazygit      # TUI for git
  make         # build tool
  mise         # Development tool manager
  neovim       # Modern vim
  nushell      # alternative to zsh, fish or bash
  ripgrep      # Fast grep replacement
  starship     # Cross-shell prompt
  tmux         # Terminal multiplexer
  zellij       # Tmux alternative
  zoxide       # Smarter cd command
  zsh          # ZSH shell
)

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to check if a package is already installed via brew
brew_package_installed() {
  brew list "$1" &> /dev/null
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
  # Skip comments (lines starting with #)
  if [[ "$package" == \#* ]] || [[ -z "$package" ]]; then
    continue
  fi

  # Check if the package is already installed
  if brew_package_installed "$package"; then
    echo "✅ $package is already installed, skipping..."
  else
    echo "📥 Installing $package..."
    brew install "$package"
  fi
done

echo "🎉 Homebrew packages installation completed!"

# Reminder about customizing packages
echo ""
echo "📝 Note: You can customize the list of packages by editing the BREW_PACKAGES array in this script."
echo "   Current location: $(readlink -f "$0")"
