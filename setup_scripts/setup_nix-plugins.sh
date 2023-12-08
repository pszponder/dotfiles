#!/usr/bin/env bash

# https://zsh.sourceforge.io/
# https://starship.rs/
# https://neovim.io/
# https://www.gnu.org/software/stow/
# https://github.com/junegunn/fzf
# https://github.com/BurntSushi/ripgrep
# https://github.com/sharkdp/bat
# https://github.com/eza-community/eza
# https://github.com/sharkdp/fd
# https://github.com/dalance/procs
# https://github.com/chmln/sd
# https://github.com/bootandy/dust
# https://github.com/ClementTsang/bottom
# https://github.com/dbrgn/tealdeer
# https://github.com/pemistahl/grex
# https://github.com/ajeetdsouza/zoxide
# https://github.com/jesseduffield/lazygit
# https://github.com/dandavison/delta
# https://github.com/Canop/broot
# https://github.com/lotabout/skim
# https://github.com/XAMPPRocky/tokei
# https://github.com/jdx/rtx
# https://github.com/Wilfred/difftastic
# https://jqlang.github.io/jq/

# Enable unfree packages
export NIXPKGS_ALLOW_UNFREE=1

# Install CLI tools
nix-env -iA \
	nixpkgs.git \
	nixpkgs.neovim \
	nixpkgs.fzf \
	nixpkgs.ripgrep \
	nixpkgs.bat \
	nixpkgs.eza \
	nixpkgs.lsd \
	nixpkgs.fd \
	nixpkgs.procs \
	nixpkgs.sd \
	nixpkgs.du-dust \
	nixpkgs.bottom \
	nixpkgs.tealdeer \
	nixpkgs.grex \
	nixpkgs.zoxide \
	nixpkgs.lazygit \
	nixpkgs.delta \
	nixpkgs.broot \
	nixpkgs.skim \
	nixpkgs.tokei \
	nixpkgs.difftastic \
	nixpkgs.jq \
	nixpkgs.xclip \
	nixpkgs.lf

# TODO: Add Brave browser, wezterm, kitty (need https://github.com/nix-community/nixGL), vscode, postman, discord, obsidian, etc.
# # Install Programs
# nix-env -iA \
# 	nixpkgs.brave \
# 	nixpkgs.vscode \
# 	nixpkgs.discord \
# 	nixpkgs.obsidian \
# 	nixpkgs.postman