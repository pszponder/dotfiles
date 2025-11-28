# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Auto-start Hyprland on TTY1 if available
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && command -v Hyprland >/dev/null 2>&1; then
    exec Hyprland
fi
