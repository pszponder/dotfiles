# ~/.zshrc
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

# 🌟 Starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# Atuin (Magical Shell History)
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# 🧠 Mise (tool version manager)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# 🔄 History control
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt INC_APPEND_HISTORY          # Write to history immediately, not on shell exit
setopt SHARE_HISTORY               # Share command history data
setopt HIST_IGNORE_DUPS            # Ignore duplicate entries
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS          # Remove superfluous blanks
setopt HIST_VERIFY                 # Don't execute when recalled from history
setopt EXTENDED_HISTORY            # Record command timestamp

# ✨ Completions
autoload -Uz compinit && compinit

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