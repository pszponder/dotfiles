{ lib, config, user, ... }:

# Homebrew management via nix-homebrew, shared across Macs. nix-darwin-only.
# GUI apps on macOS live here as casks (not as Nix packages).
let
  cfg = config.modules.darwin.homebrew;
in
{
  options.modules.darwin.homebrew.enable = lib.mkEnableOption "Homebrew management via nix-homebrew" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      inherit user;
    };

    homebrew = {
      enable = true;
      # "none" leaves Homebrew-managed software alone. Do NOT set "zap" until the
      # brews/casks lists below are populated: "zap" uninstalls every formula/cask
      # not listed here, so with empty lists the first switch wipes all manually
      # installed Homebrew software.
      onActivation.cleanup = "none";
      onActivation.autoUpdate = true;
      onActivation.extraFlags = [ "--force" ];
      # Mirrors scripts/homebrew/Brewfile's macOS-only casks/brews (fonts, GUI
      # apps, and formulae with no nixpkgs equivalent) so the nix-managed path
      # has parity with the standalone Homebrew bootstrap path. Formulae/casks
      # already covered by ../cli.nix (fleet-wide, e.g. delta/mise/starship,
      # and herdr via the llm-agents.nix flake input) are deliberately left
      # out here to avoid managing the same tool twice.
      #
      # herdr is NOT covered by cli.nix on x86_64-darwin (Intel Macs) - the
      # llm-agents.nix input only publishes x86_64-linux/aarch64-linux/
      # aarch64-darwin. Uncomment below if this host is an Intel Mac.
      brews = [
        # "herdr"
      ];
      casks = [
        "claude-code"
        "discord"
        "font-caskaydia-cove-nerd-font"
        "font-caskaydia-mono-nerd-font"
        "font-jetbrains-mono-nerd-font"
        "ghostty"
        "helium-browser"
        "hiddenbar"
        "obsidian"
        "orbstack"
        "raycast"
        "zed"
        "zen"
      ];
    };
  };
}
