## Features
- [ ] Add applications
    - [ ] handy (speech to text)
    - [ ] [sbx](https://www.docker.com/products/docker-sandboxes/)
    - [ ] [nubjs](https://nubjs.com/)
    - [ ] Ghostty terminal on linux
    - [ ] [Claude Powerline](https://www.npmjs.com/package/@owloops/claude-powerline)
  - [ ] [postcard - email client](https://postcard.gxanshu.in/)
- Review comments in codebase, the comments seem pretty wordy, can they be simplified in places without loosing meaning?
- [ ] Add a utility script into ./scripts directory for logging (copy the logging template in `.chezmoitemplates`)

## Omarchy

- [ ] Are my dotfiles compatible with Omarchy? If not, what changes are needed to make them compatible?
- [ ] [typecraft - You installed Omarchy, Now What?](https://www.youtube.com/watch?v=d23jFJmcaMI)
    - [ ] [typecraft-dev/omarchy-supplement](https://github.com/typecraft-dev/omarchy-supplement)
- [ ] Add Omarchy Debloat script(s)
- [ ] Use AI to review [TheBlackDon - Bazzite: You are WRONG its not Restricted at all!](https://gitlab.com/theblackdon/dcli-bootc) and extract how to create a custom image (make my own version so that I understand it) should this be part of my dotfiles / justfiles?

- [ ] Create a bootstrap script for omarchy and use the `omarchy pkg add` or `omarchy pkg-aur-add` to install  system level / global packages
- [ ] Think about installing system level / global packages (like eza, fzf, just, etc.) using the system package manager and mise on project-level packages
    - [ ] Should we add another `config.omarchy.toml.tmpl` file to only run if Omarchy is detected? This would allow us to have Omarchy-specific configuration that only runs when Omarchy is detected, and not on other systems. Or maybe if not omarchy-specific, arch-specific
- [ ] Review the default dotfiles omarchy adds to `~/.config` and determine if I want to incorporate them into my dotfiles

```
chezmoi has no built-in "is this Omarchy" detection — Omarchy isn't a distro, it's an Arch layer, so .chezmoi.osRelease will just report Arch (ID=arch), not Omarchy. But you can easily detect it yourself in a chezmoi template or script, since Omarchy leaves clear markers:

- Env var: {{ if env "OMARCHY_PATH" }} — set by the uwsm session, present whenever you're actually in an Omarchy session.
- Filesystem: check for /usr/share/omarchy or run test -d /usr/share/omarchy in a run_onchange_/template — works even outside a live session (e.g. during provisioning before login).
- Command presence: {{ if lookPath "omarchy" }} (chezmoi template function) or shell out to omarchy-cmd-present omarchy.

Most practical pattern for your dotfiles repo: use .chezmoi.toml.tmpl to set a custom template variable like {{ $isOmarchy := (stat "/usr/share/omarchy") }} or check the env var, then gate Omarchy-specific config blocks (hyprland, waybar/quickshell configs, theme templates, etc.) behind that variable so the same chezmoi source works on non-Omarchy machines too.
```

## NixOS

- [ ] Review list of applications installed in `cli.nix` and compare to applications from `homebrew` and `mise`
- [ ] Maybe I should just install mise as a CLI tool and then use mise to manage the rest of my CLI tools via `mise install` and `mise sync`? This would allow me to manage all my CLI tools in one place, and also allow me to easily switch between different versions of the same tool if needed.
- [ ] Add instructions on adding git and chezmoi temporarily to `/etc/nixos/configuration.nix` under the `environment.systemPackages` on a new NixOS system before being able to install the dotfiles and flake.
    - [ ] Also add to `configration.nix` => `programs.nix-ld.enable = true;`
- [ ] Refactor `nix-host-init class hostname` in justfile to point to a shell script

```
I get an error when trying to install chezmoi in NixOS

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply pszponder
info found chezmoi version 2.72.0 for latest/linux/amd64
info found glibc version 2.42
info installed bin/chezmoi
Could not start dynamically linked executable: bin/chezmoi
NixOS cannot run dynamically linked executables intended for generic linux environments out of the box. For more information, see: https://nix.dev/permalink/stub-ld

---

This is NixOS's standard issue with dynamically-linked prebuilt binaries — the fix is nix-ld, not messing with chezmoi itself.

  Called nixos 2 times

The error is standard on NixOS — the chezmoi installer downloads a generic dynamically-linked Linux binary, but NixOS has no /lib64/ld-linux-x86-64.so.2 stub by default, so the binary can't find its dynamic linker.

Recommended fix: enable nix-ld

Add this to your NixOS configuration (e.g. configuration.nix):

programs.nix-ld.enable = true;

Then sudo nixos-rebuild switch. This installs a dynamic linker shim that lets any generic Linux binary (not just chezmoi) run unmodified — useful beyond just this install script.

Alternative: install chezmoi as a Nix package instead, avoiding the curl-script approach entirely:

  Called nixos

chezmoi 2.72.0 is in nixpkgs unstable (matching the version the script tried to fetch). Since you're already using chezmoi/Nix together, the cleaner path is:

- Add pkgs.chezmoi to your home.packages or environment.systemPackages, rebuild, then run chezmoi init --apply pszponder using the Nix-provided binary (no dynamic-linking issue at all).

If you just want the quick one-off fix, programs.nix-ld.enable = true; is simplest since it fixes this class of problem generally. Want me to look at your NixOS config files in this repo and add one of these?

```

## Bugfixes

## Uncategorized

- [ ] https://cadu.dev/running-neovim-on-devcontainers/
- [ ] https://www.youtube.com/watch?v=rqpiVgWZBOg&t=130s
- [ ] https://github.com/rio/dotfiles
- [ ] distrobox?
- [ ] [From Dotfiles to Portable Dev Environments](https://dakaiser.substack.com/p/from-dotfiles-to-portable-dev-environments)
- [ ] Review [archinstall](https://nickjanetakis.com/blog/walking-through-a-minimal-arch-linux-set-up-with-archinstall)