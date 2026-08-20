{ lib, config, ... }:

# Kanata keyboard remapper, declared via upstream's services.kanata module.
# That module runs kanata as a systemd DynamicUser with supplementary access
# to /dev/uinput and flips on hardware.uinput.enable itself — no manual udev
# rules, kernel module loading, or group wiring needed here, unlike the
# imperative setup used on macOS (scripts/macos/kanata_setup.sh) and non-NixOS
# Linux (scripts/linux/kanata_setup.sh).
let
  cfg = config.modules.nixos.kanata;
in
{
  options.modules.nixos.kanata.enable = lib.mkEnableOption "kanata keyboard remapper";

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards.default.configFile = ../../../home/dot_config/kanata/kanata.kbd;
    };
  };
}
