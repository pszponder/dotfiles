{ user, ... }:

# Host-specific darwin base. Shared, reusable pieces live in ../../modules/darwin/
# (system-defaults.nix, homebrew.nix) — the flake imports them for every darwin
# host automatically, so toggle them here rather than adding/removing imports.
{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  # allowUnfree and experimental-features come from ../../modules/common.nix.

  # Both default to true; listed explicitly here as the toggle point for this
  # host. Set to false to opt a Mac out of Homebrew management or the shared
  # macOS UI defaults.
  modules.darwin.systemDefaults.enable = true;
  modules.darwin.homebrew.enable = true;

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };

  system.stateVersion = 6;
}
