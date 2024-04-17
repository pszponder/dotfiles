# =======================
# ENVIRONMENTAL VARIABLES
# =======================
set -x DOTFILES "$HOME/.config"

# ============================
# Fish shell specific settings
# ============================
# Disable fish greeting message
set -U fish_greeting

# =================================================================
# Load linuxbrew (packages) and mise (programming language manager)
# =================================================================
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
eval "$(mise activate)"

# ===================================================
# Commands to run in interactive sessions can go here
# ===================================================
if status is-interactive

    # Load starship shell prompt
    starship init fish | source

    # Enable vi mode in fish shell
    fish_vi_key_bindings

    # Enable using Zoxide (https://github.com/ajeetdsouza/zoxide)
    zoxide init fish | source

    # Ripgrep config
    set -x RIPGREP_CONFIG_PATH "$DOTFILES/ripgrep/ripgreprc"
end

# =======
# Aliases
# =======
source $DOTFILES/fish/aliases/aliases
source $DOTFILES/fish/aliases/aliases_git