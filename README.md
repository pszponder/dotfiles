# Dotfiles

## How to Run / Setup

### Clone and Apply Dotfiles (New Machine)

If you don't yet have [chezmoi](https://www.chezmoi.io/install/) installed:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply pszponder
```

If you already have [chezmoi](https://www.chezmoi.io/install/) installed, then run:

```sh
chezmoi init --apply pszponder
```

Both of these commands clone this dotfiles repo into `~/.local/share/chezmoi` and applies the managed files to your home directory.

To preview what would change without applying:

```sh
chezmoi init pszponder
chezmoi diff
chezmoi apply
```

### Adding / Modifying Files

To start managing a new dotfile with chezmoi:

```sh
# Add a file to chezmoi's source state
chezmoi add ~/.bashrc

# Add an entire directory
chezmoi add ~/.config/nvim
```

To edit a managed file:

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
```

> **Note:** This repo uses `.chezmoiroot` set to `home/`, so all managed source files live under the `home/` directory in the repo.

### Managing the Git Repo

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

## Organization

Code repositories are organized in the following location: `~/repos/<REMOTE>/<NAMESPACE>/<REPO>`
- Example => `~/repos/github/pszponder/<REPO_NAME>`

### Directory hierarchy:

```txt
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

- **~/repos/**      - Where all your repos go
- **~/sandbox/**    - Place to store experiments and tests
- **~/courses/**    - Place course materials here
- **~/resources/**  - Books, cheat sheets, etc.

Refer to `scripts/setup_directories.sh` to view/edit the predefined directories created by this repo.

## Configuring Git / SSH

Refer to `./docs/ssh_configuration.md` for more information on configuring SSH and Git on your system

## Troubleshooting

## TODOs
- [ ] fresh install troubleshooting
    - [ ] bat failed
    - [ ] mise up failed
        - [ ] install node before installing other tools with mise?
    - [ ] After installation of dotfiles, do we have to re-source so that mise installs successfully?
- [ ] Move package installation to a separate script. That way, we can run it separately and not have to worry about it when applying dotfiles on a new machine.
- [ ] Get Atuin working with bash
- [ ] Terminals
    - [ ] Configure Ghostty quickterminal (see this article for reference https://www.omgubuntu.co.uk/2025/10/ghostty-1-2-new-features-for-linux)
    - [ ] Setup Kitty [quick access terminal](https://sw.kovidgoyal.net/kitty/kittens/quick-access-terminal/)
- [ ] Configure Zed Editor
- [ ] Investigate and copy interesting configuration / applications / dotfiles from [omarchy](https://github.com/basecamp/omarchy)
- [ ] Checkout apps from [Charm](https://charm.land/apps/) such as Skate, Glow, Wishlist, Pop etc.
- [ ] Investigate installing [limactl](https://www.youtube.com/watch?v=2SGyhd5OI-c)

## Resources / References

- [Arch Package Repository](https://aur.archlinux.org/packages)
- [AUR - Arch User Repository](https://aur.archlinux.org/packages)
- [Morganamilo/paru: Feature packed AUR helper](https://github.com/Morganamilo/paru)
- [Home | mise-en-place](https://mise.jdx.dev/)
- [Mise: The BEST Way to Manage Versions of Node, Python, Go (and Much More...)](https://www.youtube.com/watch?v=eKJCnc0t8V0)
- [DevOps Toolbox - The Holy Grail of Developer CLIs - mise](https://www.youtube.com/watch?v=-_o1AS3q6xo)
- [Warp Terminal - Installation and Setup](https://docs.warp.dev/getting-started/readme-1/installation-and-setup#linux)
- [Catppuccin Color Pallete](https://catppuccin.com/palette/)