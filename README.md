# Dotfiles

This repository manages home-directory configuration with chezmoi. `chezmoi apply` does not install software, applications, services, shells, or operating-system preferences.

## Apply Dotfiles

On first run, chezmoi prompts for the Git identity used by the managed Git configuration:

| Variable    | Description                    |
| ----------- | ------------------------------ |
| `git_name`  | Your full name for Git commits |
| `git_email` | Your email for Git commits     |

For interactive setup:

```sh
# Without chezmoi installed
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply pszponder
```

```sh
# With chezmoi already installed
chezmoi init --apply pszponder
```

For non-interactive setup, provide the identity values:

```sh
GIT_NAME="Your Name" \
GIT_EMAIL="you@example.com" \
chezmoi init --apply pszponder
```

`chezmoi apply` manages the dotfiles and, on its first run, creates the [default directories](docs/directory_structure.md), links `~/repos/github/pszponder/dotfiles` to the chezmoi source directory, and bootstraps [default SSH keys](docs/ssh_configuration.md). Existing directories and keys are preserved.

The repository manages a Brewfile and mise configuration as dotfiles only. `chezmoi apply` never installs or synchronizes software.

To preview changes before applying them:

```sh
chezmoi init pszponder
chezmoi diff
chezmoi apply
```

## Installing Software

Installing and synchronizing software is not part of `chezmoi apply` and is handled separately through `just`. Run these commands from this repository:

```sh
just brew-install
just flatpak-install
just nerd-fonts-install
just mise-install
```

Install commands also synchronize the managed package configuration. Run `just brew-sync`, `just flatpak-sync`, or `just mise-sync` separately when you want to reapply a managed package configuration without reinstalling the package manager.

## Adding / Modifying Files

When using `chezmoi`, you generally *edit the chezmoi source files* in `~/.local/share/chezmoi` and then apply the changes to `$HOME` rather than editing the file directly in `$HOME`.

To start managing a new dotfile with chezmoi:

```sh
# Add a file to chezmoi's source state
chezmoi add ~/.bashrc

# Add an entire directory
chezmoi add ~/.config/nvim
```

To edit an already managed file:

```sh
# Open the source version in your $EDITOR
chezmoi edit ~/.bashrc

# Or edit directly and then re-add
vim ~/.bashrc
chezmoi re-add ~/.bashrc
```

After making changes, preview and apply:

```sh
# See what would change
chezmoi diff

# Apply changes to your home directory
chezmoi apply

# ALTERNATIVELY, combine editing and applying in one step
chezmoi edit ~/.bashrc --apply
```

> **Note:** This repo uses `.chezmoiroot` set to `home/`, so all managed source files live under the `home/` directory in the repo.

## Managing the Git Repo

chezmoi provides a `cd` command that opens a shell in the source directory, and a `git` passthrough for running git commands directly:

```sh
# Open a shell in the chezmoi source directory
chezmoi cd

# Or run git commands without leaving your current directory
chezmoi git -- status
chezmoi git -- add -A
chezmoi git -- commit -m "update dotfiles"
chezmoi git -- push
```

To pull the latest changes from the remote and apply them:

```sh
# Pull and apply in one step
chezmoi update

# Or pull without applying
chezmoi git -- pull
chezmoi diff
chezmoi apply
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
- [Catppuccin Color Pallete](https://catppuccin.com/palette/)
- [Homebrew](https://brew.sh/)
- [Flatpak](https://flatpak.org/)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Just](https://github.com/casey/just)
- [chezmoi](https://www.chezmoi.io/)
- [mise](https://mise.jdx.dev/)

AI
- [Matt Pocock - AIHero - AI Skills for Real Engineers](https://www.aihero.dev/skills)