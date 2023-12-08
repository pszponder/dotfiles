# .zprofile is sourced only once at every login.
# https://www.zerotohero.dev/zshell-startup-files/

# +----------+
# | RTX PATH |
# +----------+
export PATH="$HOME/.local/share/rtx/shims:$PATH" # For Intellij, VSCode and other IDEs

# +----------------------+
# | GLOBAL VISUAL EDITOR |
# +----------------------+
export EDITOR="nvim"
# export EDITOR='code --wait'