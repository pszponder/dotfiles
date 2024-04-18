#!/usr/bin/env bash

# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
# https://www.jakewiesler.com/blog/zsh-as-default-shell
# https://www.youtube.com/watch?v=Kt8MCkM2d7M

# TODO: Install / Configure Powerline fonts
# TODO: Install Starship Prompt

# Append zsh to /etc/shells (valid login shells)
echo "Installing ZSH..."
sudo apt install zsh
# brew install zsh
command -v zsh | sudo tee -a /etc/shells # Append zsh to /etc/shells (valid login shells)

# Change default Shell to ZSH
sudo chsh -s $(which zsh) $USER
echo "Finished installing ZSH. May need to log out / back in for changes to appear"

# Change directory for zsh config (ZDOTDIR)
echo "ZDOTDIR=~/.config/zsh" | sudo tee -a /etc/zsh/zshenv