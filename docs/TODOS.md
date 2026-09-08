## Features
- [ ] Add docker install script to Justfile and Makefile in case docker needs to be installed on system
- [ ] Codex add a visual indicator of context usage in the cli
- [ ] Add applications
    - [ ] [sbx](https://www.docker.com/products/docker-sandboxes/)
    - [ ] [nubjs](https://nubjs.com/)
    - [ ] Ghostty terminal on linux
    - [ ] [Claude Powerline](https://www.npmjs.com/package/@owloops/claude-powerline)
    - [ ] Install distrobox?
  - [ ] [postcard - email client](https://postcard.gxanshu.in/)
- Review comments in codebase, the comments seem pretty wordy, can they be simplified in places without loosing meaning?
- [ ] Add Ghostty [Quick Terminal](https://dbushell.com/2025/04/11/ghostty-macos-quick-terminal/) (do I need quick terminal If using hyprland, can I just toggle a floating scratchpad terminal instead?)
  - [ ] Only add the quick terminal for non-omarchy setups
- [ ] Add jujutsu [dynamic completions](https://docs.jj-vcs.dev/latest/install-and-setup/#dynamic-completions) to bash and zshrc

## Omarchy
- [ ] Install Apps
  - [ ] Install [toolboxes](https://github.com/ublue-os/toolboxes) / [distrobox](https://wiki.archlinux.org/title/Distrobox)
- [ ] Set the computer to [sleep after 15 minutes](https://omarchy.org/manual/system-sleep/) -> https://github.com/omacom/omarchy/issues/9931
- [ ] [Dotfiles — The Omarchy Manual](https://omarchy.org/manual/dotfiles/)
- [ ] Add shell functions to dotfiles: [Shell Functions — The Omarchy Manual](https://omarchy.org/manual/shell-functions/)
- [ ] Review the default dotfiles omarchy adds to `~/.config` and determine if I want to incorporate them into my dotfiles
  - [ ] [bashrc](https://github.com/basecamp/omarchy/blob/quattro/default/bashrc)
  - [ ] btop
  - [ ] ghostty
  - [ ] cliamp
  - [ ] git
  - [ ] herdr
    - [ ] Incorporate herdr layout functions into dotfiles
  - [ ] hypr (should we overwrite or merge with our own hyprland config?)
  - [ ] kitty
  - [ ] lazygit
  - [ ] nvim (omarchy's implementation of lazyvim)
    - [ ] Determine which version of nvim to use, then update the nvim aliases in `aliases` and the EDITORS defined in `executable_env.sh`
    - [ ] Perhaps use Omarchy's default when on omarchy, and lazynvim when not on omarchy? (can omarchy lazynvim work for non-omarchy installs)
  - [ ] obsidian
  - [ ] opencode
  - [ ] tmux
    - [ ] Incoporate Tmux layout functions into dotfiles
  - [ ] Zed Editor
- [ ] Setup [CLIAMP — Terminal Music Player](https://www.cliamp.stream/) with my preferred youtube / youtube music / spotify channels, etc.

## Bugfixes

## Uncategorized

- [ ] Use AI to review [TheBlackDon - Bazzite: You are WRONG its not Restricted at all!](https://gitlab.com/theblackdon/dcli-bootc) and extract how to create a custom image (make my own version so that I understand it) should this be part of my dotfiles / justfiles?
- [ ] https://cadu.dev/running-neovim-on-devcontainers/
- [ ] https://www.youtube.com/watch?v=rqpiVgWZBOg&t=130s
- [ ] https://github.com/rio/dotfiles
- [ ] distrobox?
- [ ] [From Dotfiles to Portable Dev Environments](https://dakaiser.substack.com/p/from-dotfiles-to-portable-dev-environments)
- [ ] Review [archinstall](https://nickjanetakis.com/blog/walking-through-a-minimal-arch-linux-set-up-with-archinstall)
