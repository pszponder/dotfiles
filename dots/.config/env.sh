# ~/.config/env.sh

# ─── Default Editors ───────────────────────────────
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# ─── Pager ─────────────────────────────────────────
export PAGER="less"
export MANPAGER="bat --paging=always"

# ─── Locale and Language ───────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ─── XDG Base Directory Spec ───────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ─── History Configuration ─────────────────────────
export HISTSIZE=5000
export HISTFILESIZE=10000

# ─── GitHub CLI ────────────────────────────────────
export GH_EDITOR="$EDITOR"

# ─── Language Versions ─────────────────────────────
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# ─── FZF Options ───────────────────────────────────
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# ─── Custom Bin Paths ──────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
