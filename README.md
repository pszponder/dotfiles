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

### Mac Configuration
- [NetworkChuck - 50 macOS Tips and Tricks Using Terminology](https://www.youtube.com/watch?v=qOrlYzqXPa8)
- [Snazzy Labs - 25 Mac Settings You have to Change](https://www.youtube.com/watch?v=psPgSN1bPLY)
- [Syntax - Set up a Mac for Power Users and Developers](https://www.youtube.com/watch?v=GK7zLYAXdDs)
- [Sane Defaults for MacOS](https://macowners.club/posts/sane-defaults-for-macos/)

### Kanata (Keyboard Configurator)
- [Dreams of Code - Turning the works key on a keyboard into the mos useful one](https://www.youtube.com/watch?v=XuQVbZ0wENE)
- [Dreams of Code - kanata - caps2esc.kbd](https://www.youtube.com/watch?v=XuQVbZ0wENE)
- [Dreams of Code - This weird keyboard technique has improved the way I type](https://www.youtube.com/watch?v=sLWQ4Gx88h4&list=PLZbzMyCByWJ3KmJfRlzus4BhryPs1nsyU&index=9)
- [Dreams of Code - kanata - home-row-mods](https://github.com/dreamsofcode-io/home-row-mods/tree/main/kanata)
- [jaycedam/install_kanata_macos.sh](https://gist.github.com/Jaycedam/4db80fc49c1d23c76c90c9b3e653c07f)


## TODOs

- [ ] Automate setup of zsh as default shell `chsh -s $(which zsh)` on new systems
- [ ] Add nixos section
- [ ] Figure out if there is a way to use stow to replace files which are already present in the home directory with the ones from the dotfiles repo
- [ ] Consider using nix darwin / nix configurations
- [ ] Add homerow mods for karabiner elements
- [ ] Setup tiling window manager on mac (Aerospace or yabai)
    - [ ] https://www.youtube.com/watch?v=5nwnJjr5eOo
- [ ] Create a Makefile or justfile to automate the installation process (or use a script)
- [ ] Investigate orbstack or colima for containerization on mac (colima is also linux compatible)

### Karabiner Elements Mappings

- [ ] Caps Lock to Escape when pressed alone, Ctrl when held
- [ ] Left Shift to Left Parenthesis when tapped, Shift when held
- [ ] Right Shift to Right Parenthesis when tapped, Shift when held
- [ ] tab + q to backtick `
- [ ] tab + shift + q to tilde ~
- [ ] x + c to left bracket [
- [ ] x + shift + c to left curly brace {
- [ ] , + . to right bracket ]
- [ ] , + shift + . to right curly brace }
- [ ] Homerow Mods
    - [ ] a to Cmd when held
    - [ ] s to Alt when held
    - [ ] d to Shift when held
    - [ ] f to Ctrl when held
    - [ ] j to Ctrl when held
    - [ ] k to Shift when held
    - [ ] l to Alt when held
    - [ ] ; to Cmd when held
- [ ] z to hyper when held
- [ ] / to hyper when held
- [ ] space + hjkl to arrow keys
- [ ] space + shift + hjkl to home/page down/page up/end