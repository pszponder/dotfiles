# Source zshrc if it exists
if [ -f ~/.config/zsh/zshrc ]; then
    source ~/.config/zsh/zshrc
fi

# Auto-start Hyprland on TTY1 if available
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && command -v Hyprland >/dev/null 2>&1; then
    exec Hyprland
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
