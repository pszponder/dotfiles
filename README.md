# Dotfiles

## Using Chezmoi

```sh
# Use chezmoi to clone down your dot-files repo from github and into specified source directory
# If you don't include --source option, chezmoi will clone your repo to ~/.local/share/chezmoi
chezmoi init --source ~/repos/github/pszponder git@github.com:pszponder/dotfiles.git
```

If you don't yet have **chezmoi** installed, use the below code snippet instead to install **chezmoi** and clone down your dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --source ~/repos/github/pszponder git@github.com:pszponder/dotfiles.git
```

Now, to apply the dotfiles using **chezmoi**, use `chezmoi apply`


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

Chezmoi
- [chezmoi](https://www.chezmoi.io/)
- [Chris Titus - Easily moving Linux installs](https://christitus.com/chezmoi/)
- [Automating Development Environments w/ Ansible & Chezmoi](https://www.youtube.com/watch?v=P4nI1VhoN2Y)
- [Conf42 - chezmoi - Dotfiles Manager across multiple machines](https://www.youtube.com/watch?v=JrCMCdvoMAw)
- [typecraft - Automate your dotfiles w/ chezomoi](https://typecraft.dev/tutorial/our-place-chezmoi)
- [Code is Everything - The ultimate dotfiles setup](https://www.youtube.com/watch?v=-RkANM9FfTM)
- [twpayne/dotfiles](https://github.com/twpayne/dotfiles)
- [kahowell/dotfiles](https://github.com/kahowell/dotfiles)
- [logandonley/dotfiles](https://github.com/logandonley/dotfiles)

Git
- [Using multiple GitHub accounts without login](https://blog.omkarpai.net/posts/multiple-git-identities/)
- [GitGuardian - 8 Easy Steps to Set Up Multiple GitHub Accounts](https://blog.gitguardian.com/8-easy-steps-to-set-up-multiple-git-accounts/)

Misc
- [Boot.dev - How I organize my local development environment](https://blog.boot.dev/misc/how-i-organize-my-local-development-environment/)

