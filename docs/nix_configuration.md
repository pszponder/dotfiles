# Nix / System Configuration (macOS and NixOS)

The `nix/` directory is a single **multi-host flake** that configures every one of
my machines — macOS (via [nix-darwin](https://github.com/nix-darwin/nix-darwin))
and NixOS.
Every machine is committed to the repo, so the whole fleet is described from one
source of truth and any machine can build any other.

## How it's laid out

```
nix/
  flake.nix                 # auto-discovers hosts, routes each by class, and
                             # injects that class's modules (see below)
  modules/
    default.nix              # imports common.nix + cli.nix — injected fleet-wide
    common.nix                # mandatory fleet-wide settings, no toggle
    cli.nix                    # cross-platform CLI packages, modules.cli.enable
                               # (pulls herdr from the llm-agents.nix flake input,
                               # see "Flake inputs" below)
    darwin/
      default.nix              # imports system-defaults.nix + homebrew.nix
      system-defaults.nix       # modules.darwin.systemDefaults.enable
      homebrew.nix              # modules.darwin.homebrew.enable
    nixos/
      default.nix              # imports fonts.nix + gui.nix + kanata.nix
      fonts.nix                 # modules.nixos.fonts.enable (default: off)
      gui.nix                   # modules.nixos.gui.enable (default: off)
      kanata.nix                # modules.nixos.kanata.enable (default: off)
  hosts/
    example-nixos/          # copy one of these to create a real host
    example-darwin/
    <hostname>/             # one folder per machine (folder name = host name)
      default.nix           # manifest: class, system, user, modules
      configuration.nix     # the actual system config
      hardware-configuration.nix   # (NixOS only) per-machine, committed
```

### Toggleable modules

Every module under `modules/` follows the same shape: it declares its own
`options.modules.<path>.enable` (via `lib.mkEnableOption`) and wraps its actual
config in `config = lib.mkIf cfg.enable { ... };`. `flake.nix` imports **every**
module for a host's class unconditionally — `modules/default.nix` fleet-wide,
plus `modules/darwin/default.nix` or `modules/nixos/default.nix` depending on
the host's `class`. Nothing needs to be added to or removed from a host's
`modules` list to turn a feature on or off; you flip a boolean in
`configuration.nix` instead:

```nix
# hosts/<hostname>/configuration.nix
{
  modules.darwin.homebrew.enable = false;   # opt this Mac out of Homebrew mgmt
  modules.nixos.gui.enable = true;          # turn on the desktop on this box
}
```

Current toggles and their defaults:

| Option                             | Class    | Default | Notes                                  |
| ----------------------------------- | -------- | ------- | --------------------------------------- |
| `modules.cli.enable`                | all      | `true`  | cross-platform CLI packages             |
| `modules.darwin.systemDefaults.enable` | darwin | `true`  | macOS UI defaults                       |
| `modules.darwin.homebrew.enable`    | darwin   | `true`  | Homebrew via nix-homebrew               |
| `modules.nixos.fonts.enable`        | nixos    | `false` | placeholder — fill in a real font list  |
| `modules.nixos.gui.enable`          | nixos    | `false` | placeholder — fill in a real DE/WM      |
| `modules.nixos.kanata.enable`       | nixos    | `false` | kanata keyboard remapper                |

`modules/common.nix` (fleet-wide `allowUnfree`, `nix.settings.experimental-features`)
has no toggle — it's mandatory plumbing, not an optional feature.

Adding a new toggleable module: drop a file with the same `options.modules.<x>.enable`
/ `config = lib.mkIf cfg.enable { ... }` shape into `modules/`, `modules/darwin/`,
or `modules/nixos/`, then add it to that directory's `default.nix` imports list.
No `flake.nix` or host changes needed — every host of that class picks it up
automatically (default `false` unless you set otherwise), and can toggle it on
per-host.

## Installing Nix

If Nix is not installed, run this from the repository root before scaffolding a
host:

```sh
just nix-install
```

This runs `scripts/cli/nix_install.sh`, which installs Nix with `nix-command` and
flakes enabled. The command requires `just` and `curl`. If `just` is not
available yet, run the installer directly:

```sh
sh scripts/cli/nix_install.sh
```

## First machine setup

Get this repository onto the machine first. With chezmoi, the standard setup
also creates the expected checkout at `~/.local/share/chezmoi`:

```sh
chezmoi init --apply pszponder
cd ~/.local/share/chezmoi
```

If Nix is not installed, run `sh scripts/cli/nix_install.sh` from this checkout
and start a new shell so the Nix commands are on `PATH`. The `just nix-install`
shortcut is equivalent when `just` is already available.

Create a host directory whose name exactly matches the hostname detected by the
rebuild script. Use the machine's short hostname on Linux, or
`scutil --get LocalHostName` on macOS:

```sh
just nix-host-init nixos <hostname>
# On macOS:
just nix-host-init darwin <hostname>
```

This copies the matching example host and refuses to overwrite an existing
host directory. It does not edit, stage, or activate the configuration.

Edit `nix/hosts/<hostname>/default.nix` and `configuration.nix`. For NixOS,
generate and save the machine-specific hardware configuration:

```sh
nixos-generate-config --show-hardware-config \
  > nix/hosts/<hostname>/hardware-configuration.nix
```

Stage the new host directory before using the flake, because Git-backed flakes
do not include untracked files:

```sh
git add nix/hosts/<hostname>
```

Apply the first configuration manually:

```sh
# NixOS
sudo nixos-rebuild switch --flake ./nix#<hostname>

# macOS, before darwin-rebuild is installed
nix run nix-darwin -- switch --flake ./nix#<hostname>
```

After the first switch, subsequent updates can use `rebuild` from anywhere.

### Flake inputs

Besides `nixpkgs` (and `nixpkgs-nixos` for NixOS hosts), `nix-darwin`, and
`nix-homebrew`, the flake also pulls in
[`llm-agents.nix`](https://github.com/numtide/llm-agents.nix) — a community
flake packaging AI coding agent CLIs that aren't in nixpkgs proper (currently
just `herdr` — see `llmAgentsPackageNames` in `modules/cli.nix`). It's passed
to every host as the `llmAgents` specialArg
(see `flake.nix`'s `specialArgs`) rather than applied as an overlay, so a
module picks a package with `llmAgents.packages.${pkgs.stdenv.hostPlatform.system}.<name>`
and should guard with `lib.optional (pkgs' ? <name>) pkgs'.<name>` since it
only publishes `x86_64-linux` / `aarch64-linux` / `aarch64-darwin` (no
`x86_64-darwin` — Intel Macs fall back to Homebrew for those packages, see
`modules/darwin/homebrew.nix`).

### The host manifest (`hosts/<hostname>/default.nix`)

Each machine is one directory under `nix/hosts/`. Its `default.nix` is a small
manifest the flake reads to know how to build it:

```nix
{
  class = "nixos";          # one of "nixos" | "darwin"
  system = "x86_64-linux";  # e.g. x86_64-linux, aarch64-linux, aarch64-darwin
  user = "yourusername";    # primary user account on this host
  modules = [ ./configuration.nix ];   # host-specific modules only — class-wide
                                        # modules (common, cli, darwin/*, nixos/*)
                                        # are injected automatically by the flake
}
```

`flake.nix` reads every directory under `hosts/`, groups them by `class`, and
produces `nixosConfigurations.<hostname>` and `darwinConfigurations.<hostname>`
automatically. **Adding a machine is just adding a folder — the flake never
needs editing.** The folder name is the flake output attribute, so it's what you
pass after `#` in a rebuild command.

## Bootstrapping a machine

The Nix configuration is rebuilt through the `rebuild` command, which is
symlinked from `home/dot_local/bin/executable_rebuild` when the dotfiles are
installed. It detects whether `darwin-rebuild` or `nixos-rebuild` is available
and invokes the matching command through `scripts/nix/nix_rebuild.sh`.

### 1. Scaffold the host folder by hand

Copy the example folder matching your machine's class to a folder named after
your hostname, then edit it:

```sh
cp -r nix/hosts/example-nixos nix/hosts/$(hostname)      # or example-darwin
```

At minimum, edit `nix/hosts/<hostname>/default.nix` to set `user` to your actual
username (see [the host manifest](#the-host-manifest-hostshostnamedefaultnix)
below), and adjust `configuration.nix` to taste.

NixOS hosts also need a `hardware-configuration.nix`:

```sh
nixos-generate-config --show-hardware-config > nix/hosts/<hostname>/hardware-configuration.nix
```

The flake is read through Git (no `--impure`), and Git's flake fetcher only sees
**tracked or staged** files. Stage (or commit) a new host folder before
rebuilding:

```sh
git add nix/hosts/<hostname>
```

### 2. Rebuild

```sh
rebuild
```

`rebuild` runs `scripts/nix/nix_rebuild.sh`, which detects the current host and
runs the class-appropriate switch command. The current wrapper expects the
checkout at `~/.local/share/chezmoi`; adjust
`home/dot_local/bin/executable_rebuild` if your installation uses another path.

## Rebuilding an existing machine

Once a machine is set up, the day-to-day loop is just:

```sh
# edit nix/hosts/<hostname>/configuration.nix
rebuild
```

The host folder is **keyed by hostname and reused**, never recreated. `rebuild`
just finds the existing `nix/hosts/<hostname>/` and applies it — nothing is
regenerated or duplicated.

## Updating package versions

`rebuild` never changes package versions on its own — it only applies what's
already pinned in `nix/flake.lock`, so two machines rebuilding on different
days still land on identical package sets as long as they're on the same
commit. Use `nixup` (`home/dot_local/bin/executable_nixup`, once dotfiles are
applied) to bump the lock file and apply the change in one step:

```sh
nixup
```

`nixup` runs `nix flake update`. If `nix/flake.lock` didn't change (nothing
new upstream), it goes straight to `rebuild`. If it did change, `nixup` stops
short of rebuilding and prints a reminder to review and commit it through
chezmoi's git passthrough — it never commits on your behalf:

```sh
chezmoi git -- diff -- nix/flake.lock
chezmoi git -- add nix/flake.lock
chezmoi git -- commit -m "nix: update flake inputs"
rebuild
```

`just nix-update` runs the same underlying `nix flake update` (plus the same
reminder) without also rebuilding, for scripting or when you want to inspect
the update before applying it:

```sh
just nix-update
# ...review/commit as above, then...
rebuild
```

Commit promptly after an update: what a machine is running should stay
traceable to a commit, not to "whatever upstream happened to be at rebuild
time."

Two edge cases where the *same computer* may not map back to its existing folder:

- **The hostname changed.** Identity is the detected name, not the hardware. If
  you rename the machine — or `scutil --get LocalHostName` / `hostname` reports a
  different value (macOS sometimes appends suffixes like `MacBook-2` after a
  network name collision) — `nix_rebuild.sh` looks for a *new* name and won't
  find a folder. If a rebuild suddenly can't find its host, this is why: rename
  the folder to match, or pin the machine's name.

- **NixOS reinstalled on the same hardware.** The folder is reused as-is, so if
  a fresh install changed the disk layout or partition UUIDs, regenerate
  `hardware-configuration.nix` by hand and commit it:

  ```sh
  nixos-generate-config --show-hardware-config > nix/hosts/<hostname>/hardware-configuration.nix
  ```

  (Not applicable to darwin — there is no hardware file there.)

## Applying the configuration manually

Replace `<hostname>` with the name of the host folder. No `--impure` is needed —
every file the flake reads is committed.

### macOS / nix-darwin

```sh
darwin-rebuild switch --flake ./nix#<hostname>
```

First run on a fresh machine, before `darwin-rebuild` exists:

```sh
nix run nix-darwin -- switch --flake ./nix#<hostname>
```

### NixOS

```sh
sudo nixos-rebuild switch --flake ./nix#<hostname>
```

> NixOS hosts need a `hardware-configuration.nix` (bootloader/filesystem settings
> that can't be shared between machines): run `nixos-generate-config
> --show-hardware-config > nix/hosts/<hostname>/hardware-configuration.nix` and
> commit it. Until it's present, `nixos-rebuild` fails with "no root filesystem"
> / "no bootloader" assertions. It's imported automatically once it exists.

## Adding another machine later

1. Copy an `example-*` folder to `nix/hosts/<hostname>` on the new machine.
2. Adjust `nix/hosts/<hostname>/default.nix` and `configuration.nix` as needed.
3. Commit the folder.
4. `rebuild`.

That's it — because hosts are auto-discovered, the flake picks up the new machine
with no other changes.
