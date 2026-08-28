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