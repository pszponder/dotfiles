# Dotfiles

This repo contains dotfiles and configuration files managed with GNU Stow.

## Prerequisites

Install the following:

- [git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [just](https://github.com/casey/just)
- [Taplo](https://taplo.tamasfe.dev/) for Codex preferences (included in `devenv shell`).

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

Clone the repository over HTTPS and enter it:

```sh
git clone https://github.com/pszponder/dotfiles.git
cd dotfiles
```

Or, if you have SSH authentication configured for GitHub, clone using SSH directly:

```sh
git clone git@github.com:pszponder/dotfiles.git
cd dotfiles
```

If you cloned over HTTP or HTTPS, switch the `origin` remote to SSH:

```sh
just remote-ssh
```

This uses your existing SSH authentication setup.

### Create Symlinks w/ Stow

Create symlinks for the files in `dots`:

```sh
just stow
```

### Codex Preferences

Codex preferences live in `config/codex-preferences.toml`, outside the Stow tree.
Run `just bootstrap-codex-preferences` inside the development shell when setting
up a machine. `just bootstrap` also runs this step.

The Bash script adds `tui.status_line` to `$CODEX_HOME/config.toml` (default:
`~/.codex/config.toml`) only if that key is missing. Existing values, including an
empty array, are left untouched, along with comments, permissions, trusted
projects, and other local settings. Changes to the tracked defaults do not
overwrite an existing status bar configuration; remove the local key to use the
defaults again. Taplo validates the TOML before any replacement. The destination
remains a regular, untracked file; the script refuses to modify a symlink.
Close Codex before applying preferences to avoid concurrent configuration writes.

Launch with `codex` or `cx`, without a profile. After migrating from the old
aliases, open a new shell or run `unalias codex cx` before sourcing your aliases.

### Restow Dotfiles

```sh
just restow
```

### Undo / Unstow

Unlink all files in the "dots" directory.

```sh
just unstow
```

## Development checks

The Bash and Zsh configs include [devenv auto-activation hooks](https://devenv.sh/auto-activation/)
when `devenv` is installed (version 2.1 or later). After installing the dotfiles,
restart your shell and trust this repository once from its directory:

```sh
devenv allow
```

Entering the repository will then activate its development environment
automatically. Leaving it deactivates the environment. Run `devenv revoke` from
the repository to disable auto-activation for it.

Run `devenv shell` to install the pre-commit and pre-push hooks and enter the
development environment. Pre-commit runs Nix, shell, Markdown, JSON, YAML, and
TOML checks and scans staged changes for secrets. Pre-push scans the history
reachable from the pushed commit for secrets. Secret findings are redacted.

Run `prek run --all-files` inside the shell to check all tracked files. Formatters
may update files; review and stage their changes before committing again.

## References

- [resources.md](./docs/resources.md)
