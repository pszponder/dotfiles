# Default Editors
set -gx EDITOR nvim
set -gx SUDO_EDITOR $EDITOR
set -gx VISUAL $EDITOR

# Pager
set -gx PAGER less
set -gx MANPAGER "bat --paging=always"

# Locale and Language
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# XDG Base Directory Spec
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# History Configuration
set -gx HISTSIZE 5000
set -gx HISTFILESIZE 10000

# GitHub CLI
set -gx GH_EDITOR $EDITOR

# Language Versions
set -gx PYENV_VIRTUALENV_DISABLE_PROMPT 1

# FZF Options
set -gx FZF_DEFAULT_COMMAND "fd --type f"
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"

# Custom Bin Paths
set -gx PATH $HOME/.local/bin $HOME/bin $PATH
