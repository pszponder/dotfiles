{ ... }:

# Fleet-wide modules, imported for every host regardless of class. Toggleable
# modules here default enabled — see each module for its options.modules.<x>
# option and default.
{
  imports = [
    ./common.nix
    ./cli.nix
  ];
}
