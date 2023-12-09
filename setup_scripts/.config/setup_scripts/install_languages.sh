#!/usr/bin/env bash

# Installing build-essentials
# https://devguide.python.org/getting-started/setup-building/#build-dependencies
echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get build-dep python3
sudo apt-get install pkg-config
sudo apt-get install build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev

# Install rtx (Polyglot runtime manager)
# https://github.com/jdx/rtx#readme
curl https://rtx.pub/install.sh | sh

# Install NodeJS
echo "Installing NodeJS..."
rtx install node
rtx use -g node

# Install BunJS
echo "Installing BunJS..."
curl -fsSL https://bun.sh/install | bash

# Install Golang
echo "Installing Golang..."
rtx install go
rtx use -g go

# install Python
echo "Installing Python..."
rtx install python
rtx use -g python

# Install Dotnet
echo "Installing Dotnet..."
rtx install dotnet
rtx use -g dotnet

# Install BunJS
echo "Installing BunJS..."
rtx install bun
rtx use -g bun