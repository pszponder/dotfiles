# +--------------------------+
# | HOMEBREW PACKAGE MANAGER |
# +--------------------------+
# https://brew.sh/
export PATH="$HOME/.linuxbrew/bin:$PATH"

# +-------------------------------+
# | MISE POLYGLOT RUNTIME MANAGER |
# +-------------------------------+
# https://mise.jdx.dev/
export PATH="$HOME/.local/share/mise/shims:$PATH"
export DOTNET_ROOT="$(dirname $(which dotnet))"