#!/usr/bin/env zsh

# =======================================================================
# This file defines environment variables loaded into ZSH shell sessions.
# It Executes before .zshrc
# =======================================================================

# +-----+
# | ZSH |
# +-----+
export ZDOTDIR="$HOME/.config/zsh"      # Where to find dot-files related to zsh (already in /etc/zsh/zshenv)

# +-----------+
# | XDG PATHS |
# +-----------+
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export DOTFILES="$XDG_CONFIG_HOME"

# +------+
# | TMUX |
# +------+
ZSH_TMUX_CONFIG="$XDG_CONFIG_HOME/tmux/.tmux.conf"

# +----------------+
# | STARSHIP SHELL |
# +----------------+
export STARSHIP_CONFIG="$DOTFILES/starship/starship.toml" # Location of Starship Config file

# +---------------+
# | NEOVIM EDITOR |
# +---------------+
# Use neovim for any program requiring a text editor
export EDITOR="nvim"
export VISUAL="nvim"

# +-----------------+
# | RIPGREP OPTIONS |
# +-----------------+
export RIPGREP_CONFIG_PATH="$DOTFILES/ripgrep/ripgreprc"

# +------------+
# | LINUX BREW |
# +------------+
export PATH="$HOME/.linuxbrew/bin:$PATH"
