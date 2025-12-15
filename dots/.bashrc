# ~/.config/bash/bashrc - Fully merged version

# Ghostty shell integration (should be at the top)
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Only proceed for interactive shells
case $- in
    *i*) ;;
      *) return;;
esac

# Load environment variables
[ -f "$HOME/.config/env.sh" ] && source "$HOME/.config/env.sh"

# Paths
for dir in "$HOME/bin" "$HOME/.local/bin" "$HOME/.local/share/blesh" "$HOME/scripts" "/usr/local/bin"; do
  [[ ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
done
export PATH

# Source aliases
if [ -f ~/.config/aliases ]; then
  . ~/.config/aliases
fi

# VIM mode
set -o vi

# Less support
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
fi

# Alert alias for long-running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Mise Tool initialization
if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

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

# Starship initialization (must come BEFORE atuin to avoid bash-preexec detection issue)
if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
fi

# Atuin (Magical Shell History)
if command -v atuin &> /dev/null; then
  eval "$(atuin init bash)"
fi

# Zoxide initialization
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

# Optional: History enhancements
HISTCONTROL=ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s cmdhist

# History PROMPT_COMMAND (must come LAST, after all tools)
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Bash-preexec (Required for Atuin)
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

# Warpify subshells only when launched from Warp (not inside tmux)
if [[ $TERM_PROGRAM == "WarpTerminal" && -z $TMUX ]]; then
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "bash"}}\e\\'
fi
