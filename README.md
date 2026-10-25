# Dotfiles

This repo contains dotfiles and configuration files managed with GNU Stow.

## Prerequisites

Install the following:

- [git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [just](https://github.com/casey/just)

### Optional Prerequisites

- [Nix](https://nixos.org/download/) and [devenv](https://devenv.sh/getting-started/)
  for the development environment and Git hooks.

#### Numtide binary cache (only if using devenv)

Optionally enable Numtide's binary cache to download available prebuilt Codex
packages. Without it, `devenv shell` still works, but may build Codex locally.

On Linux with a Nix daemon, add the following to `/etc/nix/nix.conf`:

```ini
extra-substituters = https://cache.numtide.com
extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
```

Then restart the daemon:

```sh
sudo systemctl restart nix-daemon
```

On NixOS, configure the cache declaratively instead:

```nix
nix.settings = {
  extra-substituters = [ "https://cache.numtide.com" ];
  extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];
};
```

Apply the NixOS configuration with `sudo nixos-rebuild switch` before running
`devenv shell`.

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

## Development checks

Run `devenv shell` to install the pre-commit and pre-push hooks and enter the
development environment. Pre-commit runs Nix, shell, Markdown, JSON, YAML, and
TOML checks and scans staged changes for secrets. Pre-push scans the history
reachable from the pushed commit for secrets. Secret findings are redacted.

Run `prek run --all-files` inside the shell to check all tracked files. Formatters
may update files; review and stage their changes before committing again.

## References

- [resources.md](./docs/resources.md)
