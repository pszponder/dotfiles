# ~/.config/fish/config.fish

# Only configure in interactive shells
if status is-interactive

    # Source shared environment variables
    if test -f ~/.config/env.sh
        # TODO: Will this work correctly in fish shell?
        source ~/.config/env.sh ^/dev/null
    end

    # 🛣 Add directories to $fish_user_paths (avoid duplicates)
    for dir in ~/bin ~/.local/bin ~/scripts /usr/local/bin
        if not contains $dir $fish_user_paths
            set -U fish_user_paths $fish_user_paths $dir
        end
    end

    # VIM mode
    fish_vi_key_bindings

    # Homebrew (macOS & Linux)
    for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
        if test -f $brew_path
            eval ($brew_path shellenv)
            break
        end
    end

    # Mise (tool version manager)
    if type -q mise
        mise activate fish | source
    end

    # Starship prompt
    if type -q starship
        starship init fish | source
    end

    # Zoxide (smarter cd)
    if type -q zoxide
        zoxide init fish | source
    end

    # Warpify subshells (if using Warp terminal)
    printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
end