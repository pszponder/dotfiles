# Dotfiles

## Prerequisites

## How to Run / Setup

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/pszponder/dotfiles/main/run.sh)"
```

What does `init.sh` do?
- Download and install **chezmoi**
- Download the dotfiles repo to the **chezmoi** directory
- Apply the dotfiles from the repo to the local machine
- Performs system setup (installs applications, sets up ssh keys, etc.)
- Switches chezmoi dotfiles repo from https to ssh

For more information on **chezmoi**, refer to *./docs/chezmoi.md* and the [official chezmoi docs](https://www.chezmoi.io/)

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

### bat warning: Unknown theme 'Catppuccin Mocha'

You need to rebuild bat's cache

```sh
bat cache --build
```

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

Ansible
- [ansible/ansible](https://github.com/ansible/ansible)
- [Automating Development Environments w/ Ansible & Chezmoi](https://www.youtube.com/watch?v=P4nI1VhoN2Y)
- [Learn Linux TV - Getting Started w/ Ansible](https://www.youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70)
- [Code is Everything - The ultimate dotfiles setup](https://www.youtube.com/watch?v=-RkANM9FfTM)

Dotfiles
- [dotfiles - folke](https://github.com/folke/dot)
- [dotfiles - omerxx](https://github.com/omerxx/dotfiles)
- [dotfiles - typecraft](https://github.com/typecraft-dev/dotfiles)

Gnome
- [Typecraft - This is my favorite Linux setup](https://www.youtube.com/watch?v=O1kZd1f724U)
- [Typecraft - How to use Bash to Automate Linux!](https://www.youtube.com/watch?v=62mygqukbYk)
- [typecraft - Typecraft's crucible](https://github.com/typecraft-dev/crucible)

Tmux
- [Typecraft - Tmux for Newbs](https://typecraft.dev/tmux-for-newbs)
- [Dreams of Code - Tmux has forever changed the way I write code](https://www.youtube.com/watch?v=DzNmUNvnB04)
- [dreamsofcode-io - tmux](https://github.com/dreamsofcode-io/tmux/blob/main/tmux.conf)

Thin Client
- [Typecraft - Code from ANYTHING w/ a Thin Client setup](https://youtu.be/ZqfrtoqAGWs?si=RIwve_hdzK6wjAB9)
- [tailscale - How to get started w/ Tailscale in under 10 minutes](https://youtu.be/sPdvyR7bLqI?si=WAc2ZX9MKMZoJxpc)

Setups
- [Omarchy - DHH Arch Config](https://omarchy.org/)

Misc
- [Boot.dev - How I organize my local development environment](https://blog.boot.dev/misc/how-i-organize-my-local-development-environment/)


## Todos

- incorporate useful scripts from linutil (https://github.com/ChrisTitusTech/linutil)
- review and incorporate changes from my old dotfiles
    - ex. zsh configurations
- incorporate dotfiles from other repos (refer to resources / references section)
- setup nushell config?
    - https://www.youtube.com/watch?v=LFBOLx5KiME
    - https://www.youtube.com/watch?v=TgQZz2kGysk
- [DevOps Toolbox - 7 Amazing Terminal API tools you need to try](https://www.youtube.com/watch?v=eyXxEBZMVQI)
- Auto-configure Gnome extensions and gnome (refer to resources / references on Gnome)
    - Enable `Switch to workspace #` shortcut -> super + #
    - Gnome Extensions
        - Just Perfection
        - Space Bar
        - Switcher
        - Tactile
        - TopHat
    - `dconf dump /org/gnome/shell/extensions/ > gnome_extensions.txt`
    - `dconf load /org/gnome/shell/extensions/ < gnome_extensions.txt`
- Incorporate tmux config from old dotfiles
- Update codebase to prompt user if machine is a workstation or a server and install things accordingly (server doesn't get flatpak or any other gui tools installed, but dotfiles, cli apps & executable scripts should all be installed)
- Ansible
    - Update group vars and tasks for
        - arch
            - Instead of flatpak, prefer install using pacman or yay?
            - Install warp terminal
            - Figure out how to install warp terminal
            - Configure gnome extensions and settings
            - Configure desktop background
        - darwin
        - debian
        - fedora