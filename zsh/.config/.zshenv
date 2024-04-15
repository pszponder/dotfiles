#!/usr/bin/env zsh

# =======================================================================
# This file defines environment variables loaded into ZSH shell sessions.
# It Executes before .zshrc
# =======================================================================

# +-----+
# | ZSH |
# +-----+
export ZDOTDIR="$HOME/.config/zsh"      # Where to find dot-files related to zsh

export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

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

# +--------------------+
# | LESS PAGER OPTIONS |
# +--------------------+
# less shortcuts: https://gist.github.com/awidegreen/3854277
# j/k -- scroll down/up by one line
# h/l -- scroll left/right by one character
# d/u -- scroll down/up by half a page
# b/f -- scroll down/up by a whole page
# g/G -- go to start/end of file
# q   -- quit
# N   -- toggle line numbers
# S   -- toggle line wrapping
# v   -- open file in $EDITOR
# /   -- search forward
# ?   -- search backward
# n/N -- next/previous search result
# m   -- mark a position
# '   -- go to marked position
# &   -- filter lines by a regex
# h   -- help
export LESS='--chop-long-lines --HILITE-UNREAD --ignore-case --incsearch --jump-target=4 --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS --use-color --window=-4'

# +-----------------+
# | RIPGREP OPTIONS |
# +-----------------+
export RIPGREP_CONFIG_PATH="$DOTFILES/ripgrep/ripgreprc"