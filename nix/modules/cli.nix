{
  pkgs,
  lib,
  config,
  llmAgents,
  ...
}:

# Cross-platform CLI tooling. `environment.systemPackages` exists on NixOS,
# and nix-darwin, so this one list applies fleet-wide.
#
# Package *binaries* only — dotfiles/config for these tools are managed with
# chezmoi (see the repo's `home/`), not Nix, so don't add `programs.*` config
# here or the two systems will fight over the same files.
let
  cfg = config.modules.cli;

  # Packages sourced from github:numtide/llm-agents.nix instead of nixpkgs
  # proper (see flake.nix). Add names here to pull in more of them. That flake
  # only publishes x86_64-linux/aarch64-linux/aarch64-darwin, so on an
  # unsupported system (x86_64-darwin / Intel Macs) `llmAgentsPkgs` is empty
  # and these are silently skipped - fall back to Homebrew there instead (see
  # nix/modules/darwin/homebrew.nix).
  llmAgentsPackageNames = [
    "herdr"
  ];
  llmAgentsPkgs = llmAgents.packages.${pkgs.stdenv.hostPlatform.system} or { };
  llmAgentsPackages = map (name: llmAgentsPkgs.${name}) (
    lib.filter (name: llmAgentsPkgs ? ${name}) llmAgentsPackageNames
  );
in
{
  options.modules.cli.enable = lib.mkEnableOption "cross-platform CLI tooling" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        atuin
        bash-completion
        bat
        btop
        clipboard-jh # Slackadays/Clipboard CLI
        cmake
        curl
        delta # provides the `delta` binary the gitconfig's core.pager uses
        devenv
        direnv
        eza # modern ls
        fd
        fzf
        gawk
        gcc
        gh
        git
        gnumake
        gum
        htop
        jq
        jujutsu # jj
        just
        lazydocker
        lazygit
        mise
        neovim
        # Fleet-wide so `node` is on the *non-interactive* PATH: coding-agent
        # plugins (e.g. ponytail) spawn Node lifecycle hooks from the agent
        # process, and outside a devenv shell there is no node at all. Devenv
        # shells that pin their own nodejs still shadow this one.
        nodejs_latest
        opencode
        openssl
        pass
        pi-coding-agent
        ripgrep # rg
        ruff
        starship
        stow
        tmux
        topgrade
        tree
        tree-sitter
        ty
        unzip
        uv
        wget
        worktrunk
        yazi
        zellij
        zoxide

        # kanata is intentionally left out of this fleet-wide list: on macOS it
        # needs the Karabiner VirtualHID driver (scripts/macos/kanata_setup.sh),
        # on NixOS it's declared via modules.nixos.kanata.enable (which pulls in
        # its own package through services.kanata), and on other Linux it's
        # installed by scripts/linux/kanata_setup.sh.
      ]
      ++ llmAgentsPackages;
  };
}
