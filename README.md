# Dotfiles

## Prerequisites

### Create a chezmoi.toml file

This repository using chezmoi templates, therefore, it is important to first make sure that the expected variables are defined.

The easiest way to do this is to define a `~/.config/chezmoi/chezmoi.toml` file with a `[data]` section containing your variables.

```toml
# ~/.config/chezmoi/chezmoi.toml

# Optional: customize the source directory
# sourceDir = "~/repos/github/pszponder/dotfiles"

[data]
gitUserName = "<git_username>"
gitUserEmail = "<git_email>"
```

## How to Run / Setup

Use the below code snippet to...
- Download and install **chezmoi**
- Download the dotfiles repo to the **chezmoi** directory
- Apply the dotfiles from the repo to the local machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:pszponder/dotfiles.git
```

For more information on **chezmoi**, refer to *./docs/chezmoi.md*

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

Ansible
- [ansible/ansible](https://github.com/ansible/ansible)
- [Automating Development Environments w/ Ansible & Chezmoi](https://www.youtube.com/watch?v=P4nI1VhoN2Y)
- [Learn Linux TV - Getting Started w/ Ansible](https://www.youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70)
- [Code is Everything - The ultimate dotfiles setup](https://www.youtube.com/watch?v=-RkANM9FfTM)

Misc
- [Boot.dev - How I organize my local development environment](https://blog.boot.dev/misc/how-i-organize-my-local-development-environment/)

