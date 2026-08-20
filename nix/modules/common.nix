{ ... }:

# Fleet-wide settings imported by every host, regardless of class (NixOS,
# nix-darwin). Keep only options that are valid on both:
#   - nixpkgs.config.allowUnfree: a nixpkgs option, honored everywhere.
#   - nix.settings.experimental-features: managed by nix-darwin/NixOS; on darwin
#     the daemon is Determinate-owned (nix.enable = false) so it's harmlessly
#     ignored there (verified by evaluation).
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Binary cache for numtide/llm-agents.nix (rtk, etc.), consumed via devenv.
  # extra-* appends to the defaults so cache.nixos.org is preserved.
  # https://github.com/numtide/llm-agents.nix#binary-cache
  nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
  nix.settings.extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

  nixpkgs.config.allowUnfree = true;
}
