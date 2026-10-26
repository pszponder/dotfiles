# TODOS

## TODOS

- [ ] Use custom neovim config instead of lazyvim
- [ ] Add basic vim configuration
- [ ] Create a bootstrap script (bootstrap.sh) which will install prerequisites if they aren't available (this will help with installation on non-nix systems)

## Done

- [x] Add a justfile script to change the repo from http to ssh in case it's cloned down with http instead of ssh
- [x] add devenv environment
- [x] How does stow work if a file which needs to be symlinked already exits on the host?
- [x] Use file structure from [dotfiles_v4](https://github.com/pszponder/dotfiles_v4) and migrate over dotfiles from [dots](https://github.com/pszponder/dotfiles_v2)
- [x] Create just command (`just bootstrap-dirs`) to create default home directories per [home-directory-structure.md](home-directory-structure.md)
- [x] Create just command (`just bootstrap-ssh`) to create default ssh keys
  - [x] `~/.ssh/default` and `~/.ssh/default.pub`
  - [x] `~/.ssh/github/pszponder/personal` and `~/.ssh/github/pszponder/personal.pub`
- [x] Create a `just bootstrap` command which runs both `just bootstrap-dirs` and `just bootstrap-ssh`
