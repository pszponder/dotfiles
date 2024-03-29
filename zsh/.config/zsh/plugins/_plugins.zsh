#!/usr/bin/env zsh

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins

# ======================
# ZSH PLUGINS / PACKAGES
# ======================

# +--------------------------+
# | HOMEBREW PACKAGE MANAGER |
# +--------------------------+
# https://brew.sh/

# eval "$(/opt/homebrew/bin/brew shellenv)" # macOS (ARM) specific Homebrew path
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" # Linux specific Homebrew path

# +----------------------+
# | ZAP (PLUGIN MANAGER) |
# +----------------------+
# https://www.zapzsh.org/

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/
.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "Aloxaf/fzf-tab"
plug "kutsan/zsh-system-clipboard"
plug "MichaelAquilina/zsh-you-should-use"


# Load and initialise completion system
autoload -Uz compinit
compinit

# # +---------------------+
# # | NIX PACKAGE MANAGER |
# # +---------------------+
# if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
# 	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
# fi

# +-------------------------------+
# | MISE POLYGLOT RUNTIME MANAGER |
# +-------------------------------+
# https://mise.jdx.dev/
eval "$(~/.local/bin/mise activate zsh)"

# +----------------+
# | CUSTOM PLUGINS |
# +----------------+
source $ZDOTDIR/plugins/git/plugin_git.zsh