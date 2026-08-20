{
  description = "Multi-machine system configs";

  inputs = {
    # Used by darwin hosts (and for lib helpers here).
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # NixOS hosts build from nixos-unstable: the same tree as nixpkgs-unstable,
    # but gated on the NixOS test suite (Hydra), so it's less likely to ship a
    # broken boot/systemd generation. Pin to a release with e.g. `nixos-25.11`.
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    # For managing macOS systems
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # For managing Homebrew packages on macOS
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Packages for AI coding agent tooling not in nixpkgs proper (e.g. herdr).
    # Only publishes packages for x86_64-linux/aarch64-linux/aarch64-darwin, so
    # unavailable on x86_64-darwin (Intel Macs) — modules consuming it fall
    # back gracefully there. Follows the same nixpkgs-unstable tree as
    # `nixpkgs` above, which is what upstream tests against.
    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-nixos,
      nix-darwin,
      nix-homebrew,
      llm-agents,
      ...
    }:
    let
      lib = nixpkgs.lib;

      # Auto-discover hosts: every directory under ./hosts is a machine whose
      # ./hosts/<name>/default.nix declares its class, system, user, and modules.
      # Add a machine by dropping a new folder here — no edits to this file.
      #
      # `example-*` folders are templates (copied on disk to scaffold a new host,
      # not through the flake), so they're excluded here — else they'd
      # materialize as real flake outputs and `example-nixos` would fail
      # `nix flake check` for lacking a hardware-configuration.nix.
      hosts = lib.mapAttrs (name: _: import (./hosts + "/${name}")) (
        lib.filterAttrs (
          name: type: type == "directory" && !lib.hasPrefix "example-" name
        ) (builtins.readDir ./hosts)
      );

      hostsOfClass = class: lib.filterAttrs (_: host: host.class == class) hosts;

      specialArgs = name: host: {
        inherit (host) user;
        hostname = name;
        llmAgents = llm-agents;
      };
    in
    {
      # Folder name = machine name, so drive networking.hostName from it.
      darwinConfigurations = lib.mapAttrs (
        name: host:
        nix-darwin.lib.darwinSystem {
          inherit (host) system;
          specialArgs = specialArgs name host;
          modules = [
            ./modules/default.nix
            ./modules/darwin/default.nix
            nix-homebrew.darwinModules.nix-homebrew
            { networking.hostName = name; }
          ] ++ host.modules;
        }
      ) (hostsOfClass "darwin");

      nixosConfigurations = lib.mapAttrs (
        name: host:
        nixpkgs-nixos.lib.nixosSystem {
          inherit (host) system;
          specialArgs = specialArgs name host;
          modules = [
            ./modules/default.nix
            ./modules/nixos/default.nix
            { networking.hostName = name; }
          ] ++ host.modules;
        }
      ) (hostsOfClass "nixos");

      formatter = builtins.mapAttrs (_: pkgs: pkgs.nixfmt) nixpkgs.legacyPackages;

    };
}
