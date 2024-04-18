#!/usr/bin/env zsh

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins

# ======================
# ZSH PLUGINS / PACKAGES
# ======================

# FZF Tab
autoload -Uz compinit
compinit
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh

# Autosuggestions
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# # Syntax Highlighting
# source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fast-syntax-highlighting
source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Zsh History Substring Search
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Zsh System Clipboard
source $ZDOTDIR/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh

# Zsh You Should Use (Reminds you of your existing aliases)
source $ZDOTDIR/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# Git
source $ZDOTDIR/plugins/git/plugin_git.zsh