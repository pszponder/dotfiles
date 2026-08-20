{ ... }:

# NixOS-only modules, imported for every nixos host. Toggle individual features
# per-host via options.modules.nixos.<x>.enable in configuration.nix.
{
  imports = [
    ./fonts.nix
    ./gui.nix
    ./kanata.nix
  ];
}
