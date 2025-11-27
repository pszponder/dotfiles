# Ghostty shell integration for Bash. This should be at the top of your bashrc!
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Only proceed for interactive shells
case $- in
    *i*) ;;
      *) return;;
esac

[ -f "$HOME/.config/env.sh" ] && source "$HOME/.config/env.sh"

# Paths
for dir in "$HOME/bin" "$HOME/.local/bin" "$HOME/scripts" "/usr/local/bin"; do
  [[ ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
done
export PATH

# Source aliases
if [ -f ~/.config/aliases ]; then
  . ~/.config/aliases
fi

# VIM mode
set -o vi

# History enhancements
HISTCONTROL=ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Terminal prompt fallback
if ! command -v starship &> /dev/null; then
  PS1='\u@\h:\w\$ '
fi

# Atuin (Magical Shell History)
if command -v atuin &> /dev/null; then
  eval "$(atuin init bash)"
fi

# Mise Tool initialization
if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

# Starship initialization
if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
fi

# Homebrew (macOS & Linux)
for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -f "$brew_path" ]; then
        eval "$($brew_path shellenv)"
        break
    fi
done

# Zoxide initialization
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

# Warpify Subshells (only if using Warp Terminal)
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "bash"}}\x9c'