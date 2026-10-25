# Dotfiles

This repo contains dotfiles and configuration files managed with GNU Stow.

## Prerequisites

Install the following:

- [git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)

### Optional Prerequisites
- [just](https://github.com/casey/just)

## Installing Dotfiles on Your System

### Clone the Repository

Clone the repository and enter it:

```sh
git clone https://github.com/pszponder/dotfiles.git
cd dotfiles
```

### Create Symlinks w/ Stow

Create symlinks for the files in `dots`:

```sh
stow dots
```

### Restow Dotfiles

```sh
stow -R dots
```

### Undo / Unstow

Unlink all files in the "dots" directory.

```sh
stow -D dots
```

## References
- [resources.md](./docs/resources.md)
