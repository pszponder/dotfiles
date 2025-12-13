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
git clone https://github.com/pszponder/dotfiles.git
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
- [Michael Uloth - Switching Configs in Neovim](https://michaeluloth.com/neovim-switch-configs/)
- [Elijah Manor - Neovim Config Switcher](https://www.youtube.com/watch?v=LkHjJlSgKZY)
- [Dreams of Autonomy - This ZSH config is perhaps my favorite one yet](https://youtu.be/ud7YxC33Z3w?si=27kOpHT6xNCeLBx4)
- [Configure your Git](https://www.youtube.com/watch?v=G3NJzFX6XhY)

### TMUX
- [typecraft - Tmux for Newbs](https://www.youtube.com/playlist?list=PLsz00TDipIfdrJDjpULKY7mQlIFi4HjdR)
- [tmuxcheatsheet.com](https://tmuxcheatsheet.com/)
- [Dreams of Code - Tmux has forever changed the way I write code](https://www.youtube.com/watch?v=DzNmUNvnB04)
- [DevOps Toolbox - Tmux from Scratch to BEST MODE](https://www.youtube.com/watch?v=GH3kpsbbERo)
- [DevOps Toolbox - Hidden Tmux Power: The Missing 50%](https://www.youtube.com/watch?v=_TI8qcsiiBU)
- [tony - How to Customize Tmux (20XX Edition)](https://www.youtube.com/watch?v=XivdyrFCV4M)

### Mac Configuration References
- [Snazzy Labs - 25 Mac Settings You have to Change](https://www.youtube.com/watch?v=psPgSN1bPLY)
- [Syntax - Set up a Mac for Power Users and Developers](https://www.youtube.com/watch?v=GK7zLYAXdDs)

### Kanata (Keyboard Configurator)
- [Dreams of Code - Turning the works key on a keyboard into the mos useful one](https://www.youtube.com/watch?v=XuQVbZ0wENE)
- [Dreams of Code - kanata - caps2esc.kbd](https://www.youtube.com/watch?v=XuQVbZ0wENE)
- [Dreams of Code - This weird keyboard technique has improved the way I type](https://www.youtube.com/watch?v=sLWQ4Gx88h4&list=PLZbzMyCByWJ3KmJfRlzus4BhryPs1nsyU&index=9)
- [Dreams of Code - kanata - home-row-mods](https://github.com/dreamsofcode-io/home-row-mods/tree/main/kanata)


## TODOs

- [ ] Add nixos section
- [ ] Add an `install.sh` script to automate the installation process
    - [ ] Prompt user to install missing prerequisites (e.g., git, stow)
    - [ ] Automate cloning the repository
    - [ ] Automate stowing the dotfiles
- [ ] Figure out if there is a way to use stow to replace files which are already present in the home directory with the ones from the dotfiles repo
- [ ] Consider using nix darwin / nix configurations
- [ ] Add kanata
    - [ ] How to install Kanata? (`cargo install kanata` or `brew install kanata`?)
    - [ ] Also need to install karabiner driver???
    - [ ] On mac, kanata resets function rows so need to redefine them in Kanata
- [ ] Setup tiling window manager on mac (Aerospace or yabai)
    - [ ] https://www.youtube.com/watch?v=5nwnJjr5eOo
    - [ ]