{ pkgs, lib, config, ... }:

# NixOS graphical desktop. Off by default; enable per-host on machines that
# have a display (these options don't exist on darwin). The
# actual compositor/DE/GUI-package choices below are commented out — uncomment
# and adapt to what you want once you flip modules.nixos.gui.enable = true.
let
  cfg = config.modules.nixos.gui;
in
{
  options.modules.nixos.gui.enable = lib.mkEnableOption "NixOS graphical desktop";

  config = lib.mkIf cfg.enable {
    # Example: enable a Wayland compositor (Hyprland) + a login manager.
    # programs.hyprland.enable = true;
    # services.displayManager.gdm.enable = true;

    # Example: a traditional X11 + desktop environment instead.
    # services.xserver.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;

    # GUI applications (on macOS these would be Homebrew casks instead).
    # environment.systemPackages = with pkgs; [
    #   firefox
    #   wezterm
    # ];
  };
}
