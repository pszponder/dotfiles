#!/usr/bin/env bash

# Check if rtx is installed by brew, if not install it
if test ! $(which rtx); then
	echo "Installing rtx..."
	brew install rtx
else
	echo "rtx is already installed, installing languages from ~/.config/rtx/config.toml ..."
	rtx install
fi

# # Install NodeJS
# echo "Installing NodeJS..."
# rtx install node
# rtx use -g node

# # Install BunJS
# echo "Installing BunJS..."
# rtx install bun
# rtx use -g bun

# # Install Deno
# echo "Installing Deno..."
# rtx install deno
# rtx use -g deno

# # Install Golang
# echo "Installing Golang..."
# rtx install go
# rtx use -g go

# # install Python
# echo "Installing Python..."
# rtx install python
# rtx use -g python

# # Install Dotnet
# echo "Installing Dotnet..."
# rtx install dotnet
# rtx use -g dotnet

# # Install Rust
# echo "Installing Rust..."
# rtx install rust
# rtx use -g rust