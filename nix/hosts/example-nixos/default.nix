# Per-host manifest. The flake auto-discovers every directory under ./hosts and
# reads this file to learn how to build it. Copy this folder, rename it to your
# real hostname, and adjust the fields below.
#
#   class   one of "nixos" | "darwin"
#   system  target platform, e.g. "x86_64-linux" / "aarch64-linux" / "aarch64-darwin"
#   user    primary user account on this host
#   modules host-specific modules on top of the class-wide set the flake
#           already injects (common, cli, and — for nixos/darwin — the
#           class modules). Toggle individual class-wide features per-host
#           with `modules.<x>.enable = true/false;` in configuration.nix
#           rather than adding/removing imports here.
{
  class = "nixos";
  system = "x86_64-linux";
  user = "piotr";
  modules = [ ./configuration.nix ];
}
