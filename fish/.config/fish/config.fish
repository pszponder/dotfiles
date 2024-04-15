eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
eval "$(mise activate)"

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
