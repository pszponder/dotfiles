# ~/.config/fish/config.fish

# Add directories to path
set -U fish_user_paths $fish_user_paths ~/bin ~/scripts /usr/local/bin

# Homebrew (Linux) initialization
if test -f /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
