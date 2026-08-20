{ pkgs, lib, config, ... }:

# System fonts for NixOS graphical hosts. NixOS-only (`fonts.packages` doesn't
# exist on darwin — install Mac fonts via Homebrew casks instead). Off by
# default since headless hosts don't need fonts; enable per-host.
let
  cfg = config.modules.nixos.fonts;
in
{
  options.modules.nixos.fonts.enable = lib.mkEnableOption "system fonts for graphical NixOS hosts";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };
}
