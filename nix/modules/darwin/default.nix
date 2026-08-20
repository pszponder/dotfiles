{ ... }:

# nix-darwin-only modules, imported for every darwin host. Toggle individual
# features per-host via options.modules.darwin.<x>.enable in configuration.nix.
{
  imports = [
    ./system-defaults.nix
    ./homebrew.nix
  ];
}
