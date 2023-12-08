#!/usr/bin/env bash

# https://brew.sh/

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Brew CLI Packages
brew install \
	gcc \
	git \
	vim \
	neovim \
	fzf \
	ripgrep \
	bat \
	lsd \
	fd \
	procs \
	sd \
	dust \
	bottom \
	tealdeer \
	grex \
	zoxide \
	lazygit \
	lazydocker \
	git-delta \
	broot \
	tokei \
	jq \
	xclip \
	yazi \
	starship \
	httpie \
	yazi \
	rtx \
	stow \
	chezmoi \
	gum \

# Install Brew GUI Packages (if on macOS)
case $(uname -ms) in
'Darwin x86_64')
	target=darwin-x64
	;;
'Darwin arm64')
	target=darwin-aarch64
	;;
'Linux aarch64' | 'Linux arm64')
	target=linux-aarch64
	;;
'Linux x86_64' | *)
	target=linux-x64
	;;
esac

if [[ $target = "darwin-aarch64" ]]; then
	brew install --cask \
		brave-browser \
		google-chrome \
		firefox \
		wezterm \
		kitty \
		warp \
		visual-studio-code \
		postman \
		discord \
		obsidian \
		docker \
fi

# [topgrade (updater)](https://github.com/topgrade-rs/topgrade)
# [procs (replacement for ps written in Rust)](https://github.com/dalance/procs)
# [bat (alternative to cat)](https://github.com/sharkdp/bat)
# [sd (sed alternative)](https://github.com/chmln/sd)
# [tealdeer (tldr in rust)](https://github.com/dbrgn/tealdeer)
# [jq (manipulate json in command line)](https://jqlang.github.io/jq/)
# [lsd (ls alternative)](https://github.com/lsd-rs/lsd)
# [fd (user-friendly alternative to find)](https://github.com/sharkdp/fd)
# [zoxide (smarter cd command)](https://github.com/ajeetdsouza/zoxide)
# [ripgrep](https://github.com/BurntSushi/ripgrep)
# [Fuzzy Finder - fzf](https://github.com/junegunn/fzf)
# [navi (look up and execute shell one-liners)](https://github.com/denisidoro/navi)
# [rtx - Runtime manager (asdf rust clone)](https://github.com/jdx/rtx)
# [ctop (top-like interface for container metrics)](https://github.com/bcicen/ctop)
# [bottom (rust rewrite of top)](https://clementtsang.github.io/bottom/0.8.0/)
# [lazygit (cli git client)](https://github.com/jesseduffield/lazygit)
# [lazydocker (simple terminal UI for docker and docker-compose)](https://github.com/jesseduffield/lazydocker)
# [delta (improved diff tool)](https://github.com/dandavison/delta)
# [curlie](https://github.com/rs/curlie)
# [httpie](https://httpie.io/)
# [lf (cli file manager)](https://github.com/gokcehan/lf)
# [ranger (cli file manager)](https://github.com/ranger/ranger)
# [yazi - terminal file manager](https://github.com/sxyazi/yazi)
# [starship (shell prompt)](https://starship.rs/)
# [gum - glamorous shell scripts w/o any Go code!](https://github.com/charmbracelet/gum)
# [chezmoi - dotfile manager](https://www.chezmoi.io/)