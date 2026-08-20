{ lib, user, ... }:

{
  # Machine-specific settings (bootloader, filesystems/partitioning) can't be
  # derived from this shared config — generate them once per machine with
  # `nixos-generate-config` and drop the result at ./hardware-configuration.nix.
  # Imported conditionally so this file evaluates before that exists; rebuild
  # will fail with "no root filesystem" / "no bootloader" assertions until it's
  # in place.
  imports = lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  # ../../modules/nixos/{gui,fonts}.nix are imported for every nixos host by
  # the flake but default to `enable = false` (they're placeholders). Flip
  # these on once you've filled in a real compositor/DE and font list:
  # modules.nixos.gui.enable = true;
  # modules.nixos.fonts.enable = true;
  # modules.nixos.kanata.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
  };

  # Set ONCE to the NixOS release you first installed this machine with, then
  # never bump it. It pins stateful-data defaults (DB major versions, service
  # data layouts) so upgrades stay safe — it is NOT your package/NixOS version,
  # which comes from the nixpkgs flake input (currently nixos-unstable).
  system.stateVersion = "25.11";
}
