# Dotfiles

This repo contains dotfiles / configuration for my system.

## Prerequisites

Ensure you have the following installed on your system:
- [git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)

## Installing Dotfiles on Your System

### Clone the Repository

First, clone the repo onto the system and navigate into the repository.

```sh
git clone git@github.com/pszponder/dotfiles.git
cd dotfiles
```

### Create Symlinks w/ Stow

Symlink all files in the "dots" directory.

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

## Resources / References
- [typecraft - Never lose dotfiles again w/ GNU Stow](https://www.youtube.com/watch?v=NoFiYOqnC4o)
- [typecraft - Never Lose Your Configs Again | Article](https://typecraft.dev/tutorial/never-lose-your-configs-again)
- [Dreams of Autonomy - Stow has forever changed the way I manage my dotfiles](https://www.youtube.com/watch?v=y6XCebnB9gs)
- [Joesean Martinez - How to Easily Manage Your Dotfiles With GNU Stow](https://www.youtube.com/watch?v=06x3ZhwrrwA)
- [DevOps Toolbox - ~/.dotfiles 101: A Zero to Configuration Hero Blueprint](https://www.youtube.com/watch?v=WpQ5YiM7rD4&t=180s)