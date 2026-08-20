{ lib, config, ... }:

# macOS system UI defaults, shared across Macs. nix-darwin-only.
let
  cfg = config.modules.darwin.systemDefaults;
in
{
  options.modules.darwin.systemDefaults.enable = lib.mkEnableOption "macOS system UI defaults" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    system.defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2; # fast key repeat
        InitialKeyRepeat = 15; # short delay before repeat
        _HIHideMenuBar = true; # auto-hide the menu bar
        AppleShowAllExtensions = true;
      };
      dock.autohide = true;
      dock.persistent-apps = [
        { app = "/System/Library/CoreServices/Finder.app"; }
        { app = "/System/Applications/Mail.app"; }
        { app = "/Applications/Helium.app"; } # cask token is "helium-browser", verify app name after install
        { app = "/Applications/Ghostty.app"; }
        { app = "/Applications/Zed.app"; }
        { app = "/Applications/Obsidian.app"; }
        { app = "/Applications/Discord.app"; }
      ];
      finder.FXPreferredViewStyle = "Nlsv"; # list view by default
      finder.CreateDesktop = false; # clean desktop
      trackpad.Clicking = true; # tap to click
    };
  };
}
