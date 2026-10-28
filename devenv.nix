{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  bashFiles = "\\.(sh|bash)$|^dots/\\.(bashrc|bash_profile|profile)$|^dots/\\.config/aliases$|^dots/\\.local/bin/";
in
{
  # https://devenv.sh/packages/
  packages = [
    pkgs.betterleaks
    pkgs.bubblewrap
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    pkgs.deadnix
    pkgs.git
    pkgs.just
    pkgs.nixfmt
    pkgs.prettier
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.statix
    pkgs.stow
    pkgs.taplo
  ];

  git-hooks.hooks = {
    nixfmt.enable = true;
    statix.enable = true;
    deadnix.enable = true;
    prettier = {
      enable = true;
      files = "\\.(md|json|ya?ml)$";
    };
    taplo.enable = true;
    shfmt = {
      enable = true;
      files = bashFiles;
      types = lib.mkForce [ "file" ];
      args = [
        "-ln"
        "bash"
      ];
    };
    shellcheck = {
      enable = true;
      files = bashFiles;
      types = lib.mkForce [ "file" ];
      args = [ "--shell=bash" ];
    };
    betterleaks-commit = {
      enable = true;
      name = "Betterleaks staged secrets";
      entry = "${pkgs.betterleaks}/bin/betterleaks git --pre-commit --staged --redact --no-banner .";
      stages = [ "pre-commit" ];
      pass_filenames = false;
      always_run = true;
    };
    betterleaks-push = {
      enable = true;
      name = "Betterleaks pushed history";
      entry = "${pkgs.writeShellScript "check-pushed-secrets" ''
        exec ${pkgs.betterleaks}/bin/betterleaks git --redact --no-banner --log-opts="''${PRE_COMMIT_TO_REF:?Missing pushed commit}" .
      ''}";
      stages = [ "pre-push" ];
      pass_filenames = false;
      always_run = true;
    };
  };
}
