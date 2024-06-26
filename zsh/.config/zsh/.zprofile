# .zprofile is sourced only once at every login.
# https://www.zerotohero.dev/zshell-startup-files/

# +-------+
# | PATHS |
# +-------+
export PATH="$PATH:$HOME/.local/bin"    # Needed for ZSH
export PATH="$PATH:$HOME/.config/bin"   # Source bin directory in .config
export PATH="$PATH:$HOME/bin"           # Source bin directory in home

# +----------------------+
# | GLOBAL VISUAL EDITOR |
# +----------------------+
export EDITOR="nvim"
# export EDITOR='code --wait'

# +-------------------------------+
# | MISE POLYGLOT RUNTIME MANAGER |
# +-------------------------------+
# https://mise.jdx.dev/
export PATH="$HOME/.local/share/mise/shims:$PATH"
export DOTNET_ROOT="$(dirname $(which dotnet))"