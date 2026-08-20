# Per-host manifest — see hosts/example-nixos/default.nix for field docs.
# The fleet-wide and darwin-class modules (common, cli, system-defaults,
# homebrew, nix-homebrew) are injected automatically by the flake for every
# darwin host — toggle them per-host with `modules.<x>.enable` in
# configuration.nix instead of listing files here.
{
  class = "darwin";
  system = "aarch64-darwin"; # use "x86_64-darwin" on Intel Macs
  user = "piotr";
  modules = [ ./configuration.nix ];
}
