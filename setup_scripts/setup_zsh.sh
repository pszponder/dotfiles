#!/usr/bin/env bash

# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
# https://www.jakewiesler.com/blog/zsh-as-default-shell

# TODO: Install / Configure Powerline fonts

# Append zsh to /etc/shells (valid login shells)
echo "Installing ZSH..."
# sudo apt install zsh
brew install zsh
command -v zsh | sudo tee -a /etc/shells # Append zsh to /etc/shells (valid login shells)

# Change default Shell to ZSH
sudo chsh -s $(which zsh) $USER
echo "Finished installing ZSH. May need to log out / back in for changes to appear"

# Install zap (https://www.zapzsh.org/)
# https://www.youtube.com/watch?v=LhDMw6n3GI4
echo "Installing zap ZSH manager..."
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

# Configure zap
echo "Configuring zap..."

# Function to remove specific text from .zshrc
remove_text_from_zshrc() {
    local text_to_remove="$1"
    local zshrc_file="$HOME/.zshrc"

    # Check if .zshrc exists
    if [ -f "$zshrc_file" ]; then
        # Use sed to remove the specific text from .zshrc
        sed -i "\|$text_to_remove|d" "$zshrc_file"
        echo "Removed '$text_to_remove' from .zshrc."
    else
        echo "Error: .zshrc file not found."
    fi
}

remove_text_from_zshrc 'plug "zap-zsh/zap-prompt"'

# Setup Starship Prompt (https://starship.rs/guide/#%F0%9F%9A%80-installation)
echo "Installing Starship Prompt..."
curl -sS https://starship.rs/install.sh | sh