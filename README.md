# Dotfiles

## Prerequisites

- [chezmoi](https://www.chezmoi.io/)

## How to Run / Setup

```sh
chezmoi init --apply pszponder
```

## Organization

Code repositories are organized in the following location: `~/repos/<REMOTE>/<NAMESPACE>/<REPO>`
- Example => `~/repos/github/pszponder/<REPO_NAME>`

### Directory hierarchy:

```
~
├── repos
│   ├── github
│   │   └── pszponder
│   │       ├── repo1
│   │       ├── repo2
│   │       └── ...
│   ├── bitbucket
│   ├── gitlab
│   └── ...
├── sandbox
├── courses
└── resources
```

- **~/repos/** - Where all your repos go
- **~/sandbox/** - Place to store experiments and tests
- **~/courses/** - Place course materials here
- **~/resources/** - Books, cheat sheets, etc.

## Configuring Git / SSH

Refer to `./docs/ssh_configuration.md` for more information on configuring SSH and Git on your system

## Troubleshooting

## Shortcuts - Cosmic Desktop

### Windows
- Close Window
    - Super + Q
- Focus Window
    - Super + h,j,k,l
- Move Window
    - Super + Shift + h,j,k,l
- Maximize Window
    - Super + M
- Minimize Window
    - Super + Shift + M
- Resize Window Inwards
    - Super + Shift + R
- Resize Window Outwards
    - Super + R

### Workspaces
- Switch to Workspace 1-9
    - Super + 1-9
- Move Window to Workspace 1-9
    - Super + Shift + 1-9
- Move Window to Next Workspace
    - Super + Shift + Ctrl + L
- Move Window to Prev Workspace
    - Super + Shift + Ctrl + H

### Misc
- Switch between open windows
    - Alt + Tab
    - Super + Tab
- Open App Library
    - Super + A
- Open Launcher
    - Super
    - Super + /
- Open Workspace Overview
    - Super + W
- Lock The Screen
    - Super + Escape
- Open Default Terminal
    - Super + T
- Open Default Browser
    - Super + B
- Open File Explorer
    - Super + F

## Resources / References

Homebrew
- [Homebrew](https://brew.sh/)
- [Homebrew for Linux](https://docs.brew.sh/Homebrew-on-Linux)

Neovim
- [Kickstart Nvim](https://github.com/nvim-lua/kickstart.nvim)
- [LazyVim](https://github.com/LazyVim/LazyVim)

Fonts
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

Docker
- [SavvyNik - How to Install Docker on Ubuntu Linux](https://www.youtube.com/watch?v=tjqd1Fxo6HQ)
- [Docs - Docker - Install Docker Engine](https://docs.docker.com/engine/install/)
- [DevOps Toolbox - Docker for the impatient](https://www.youtube.com/watch?v=lSZDWY80rPw)

Dotfiles
- [dotfiles - folke](https://github.com/folke/dot)
- [dotfiles - omerxx](https://github.com/omerxx/dotfiles)
- [dotfiles - typecraft](https://github.com/typecraft-dev/dotfiles)

Tmux
- [Typecraft - Tmux for Newbs](https://typecraft.dev/tmux-for-newbs)
- [Dreams of Code - Tmux has forever changed the way I write code](https://www.youtube.com/watch?v=DzNmUNvnB04)
- [dreamsofcode-io - tmux](https://github.com/dreamsofcode-io/tmux/blob/main/tmux.conf)

Hyprland
- [Hyprland - examples](https://github.com/hyprwm/Hyprland/tree/main/example)
- [Omarchy - DHH Arch Config](https://omarchy.org/)
- [ML4W Dotfiles for Hyprland](https://github.com/mylinuxforwork/dotfiles)
- [My Linux for Work - HYPRLAND Tips and Tricks](https://www.youtube.com/watch?v=rW3JKs1_oVI&t=369s)
- [HyDE](https://github.com/HyDE-Project/HyDE)
- [HyprAccelerator](https://www.youtube.com/watch?v=Bv_CpFbf84w&t=2734s)
- [Meowrch](https://github.com/meowrch/meowrch)
- [sane1090x - How to Rice Hyprland | Full Guide](https://www.youtube.com/watch?v=Bv_CpFbf84w&t=2734s)

Rofi
- [Eric Murphy - How to Setup and Configure Rofi (The Best App Launcher)](https://www.youtube.com/watch?v=TutfIwxSE_s)

Misc
- [Boot.dev - How I organize my local development environment](https://blog.boot.dev/misc/how-i-organize-my-local-development-environment/)

## TODOS

### Arch - Hyprland

- Add network selection options to waybar
    - https://github.com/mylinuxforwork/dotfiles/tree/main/share/dotfiles/.config/waybar
- Fix brave browser asking for keyring authentication each time (potentially by installing via recommended cli command instead of from aur)
- Update browser to use Brave
- Change tiling pattern
- [HYPRLAND w/ swaylogk and wlogout. Beautiful logout menu and lock screen automated with swayidle](https://www.youtube.com/watch?v=ptmiPG_V4u8)
- [TheBlackDon - Linux Playlist](https://youtube.com/playlist?list=PLk4JqtLzOZRQsVQw4SQrqLJdZoyxaziOl&si=5dOo7HOYh14MazX6)
- [TheBlackDon - What Packages/Tools I Use For My Hyprland Config](https://www.youtube.com/watch?v=luEivVMLf0s)
- [Custom shell prompt](https://www.youtube.com/watch?v=Dz7JUHEls2A)
- Refer to [this video](https://www.youtube.com/watch?v=JmFZhRUs_mI&list=PLDK-KGioYK8olxTQHL_bpsopCnAXy2rbk&index=7) to set system fonts (`/etc/fonts/local.conf`)
- [My Linux For Work - Hyprland](https://www.youtube.com/watch?v=EujO_5KvCCo&list=PLZhEtW7iLbnB0Qa0kp9ICLViOp6ty4Rkk)
- [My Linux for Work - Setup WAYBAR, the status bar for HYPRLAND](https://www.youtube.com/watch?v=rW3JKs1_oVI&t=369s)

### Fedora - Cosmic
- Update keybindings for:
    - Enable alt+tab?
- Add ~/.config/cosmic to dotfiles