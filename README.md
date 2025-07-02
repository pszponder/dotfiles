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
- [Omarchy - DHH Arch Config](https://omarchy.org/)

Misc
- [Boot.dev - How I organize my local development environment](https://blog.boot.dev/misc/how-i-organize-my-local-development-environment/)

## TODOS

- [TheBlackDon - Linux Playlist](https://youtube.com/playlist?list=PLk4JqtLzOZRQsVQw4SQrqLJdZoyxaziOl&si=5dOo7HOYh14MazX6)
- [TheBlackDon - What Packages/Tools I Use For My Hyprland Config](https://www.youtube.com/watch?v=luEivVMLf0s)
- [Meowrch](https://github.com/meowrch/meowrch)
- [sane1090x - How to Rice Hyprland | Full Guide](https://www.youtube.com/watch?v=Bv_CpFbf84w&t=2734s)
- [sane1090x - How to rice Hyprland](https://www.youtube.com/playlist?list=PLDK-KGioYK8olxTQHL_bpsopCnAXy2rbk)
- [HyprAccelerator](https://www.youtube.com/watch?v=Bv_CpFbf84w&t=2734s)
- [Custom shell prompt](https://www.youtube.com/watch?v=Dz7JUHEls2A)
- Refer to [this video](https://www.youtube.com/watch?v=JmFZhRUs_mI&list=PLDK-KGioYK8olxTQHL_bpsopCnAXy2rbk&index=7) to set system fonts (`/etc/fonts/local.conf`)
- [My Linux For Work - Hyprland](https://www.youtube.com/watch?v=EujO_5KvCCo&list=PLZhEtW7iLbnB0Qa0kp9ICLViOp6ty4Rkk)
- [My Linux for Work - Setup WAYBAR, the status bar for HYPRLAND](https://www.youtube.com/watch?v=rW3JKs1_oVI&t=369s)
- [My Linux for Work - HYPRLAND Tips and Tricks](https://www.youtube.com/watch?v=rW3JKs1_oVI&t=369s)