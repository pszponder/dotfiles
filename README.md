# Dotfiles

## Prerequisites

## How to Run / Setup

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/pszponder/dotfiles/main/install.sh)"
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


## Todos
- Incorporate install scripts from omarchy