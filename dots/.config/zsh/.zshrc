if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Only continue if the shell is interactive
[[ $- != *i* ]] && return

[ -f "$HOME/.config/env.sh" ] && source "$HOME/.config/env.sh"

# ✨ Update PATH with common user script/tool locations
for dir in "$HOME/bin" "$HOME/.local/bin" "$HOME/scripts" "/usr/local/bin"; do
  [[ ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
done
export PATH
unset dir # Clean up loop var

# 🧩 Source aliases
if [[ -f ~/.config/aliases ]]; then
  source ~/.config/aliases
fi

# VIM mode
bindkey -v

# Homebrew (macOS & Linux)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -f "$brew_path" ]; then
        # Add brew directory to PATH first
        BREW_PREFIX="$(dirname "$(dirname "$brew_path")")"
        export PATH="$BREW_PREFIX/bin:$PATH"
        eval "$($brew_path shellenv)"
        break
    fi
done

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets / Plugins from Oh My Zsh
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
# zinit snippet OMZL::git.zsh
# zinit snippet OMZP::git
zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::docker
zinit snippet OMZP::terraform
zinit snippet OMZP::command-not-found
zinit snippet OMZP::golang
zinit snippet OMZP::python
zinit snippet OMZP::uv
zinit snippet OMZP::rust
# zinit snippet OMZP::tmux


# 🌟 Starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# Atuin (Magical Shell History)
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# # FZF Integration (Only use if not using Atuin)
# if command -v fzf &> /dev/null; then
#   eval "$(fzf --zsh)"
# fi

# 🧠 Mise (tool version manager)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# 🔄 History control
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt APPEND_HISTORY              # Append to the history file, don't overwrite it
setopt INC_APPEND_HISTORY          # Write to history immediately, not on shell exit
setopt SHARE_HISTORY               # Share command history data
setopt HIST_IGNORE_SPACE           # Ignore commands that start with space
setopt HIST_IGNORE_DUPS            # Ignore duplicate entries
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS          # Remove superfluous blanks
setopt HIST_VERIFY                 # Don't execute when recalled from history
setopt EXTENDED_HISTORY            # Record command timestamp

# ✨ Completions
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ✨ Prompt title in terminals like xterm
precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

# 🚀 Zoxide (better cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Warpify Subshells (Only if using Warp Terminal)
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'