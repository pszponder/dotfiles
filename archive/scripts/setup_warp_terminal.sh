#!/usr/bin/env bash
set -euo pipefail

command_exists() { command -v "$1" >/dev/null 2>&1; }

install_macos() {
  echo "Installing Warp on macOS..."

  if ! command_exists brew; then
    echo "Homebrew not found. Please install Homebrew first: https://brew.sh"
    exit 1
  fi

  brew install --cask warp
}

install_ubuntu() {
  echo "Installing Warp (APT-based Linux)..."

  sudo apt-get update
  sudo apt-get install -y wget gpg

  sudo mkdir -p /etc/apt/keyrings

  wget -qO- https://releases.warp.dev/linux/keys/warp.asc \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/warpdotdev.gpg >/dev/null

  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" \
    | sudo tee /etc/apt/sources.list.d/warpdotdev.list >/dev/null

  sudo apt-get update
  sudo apt-get install -y warp-terminal
}

install_fedora() {
  echo "Installing Warp (DNF-based Linux)..."

  sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc

  sudo sh -c 'echo -e "[warpdotdev]
  name=warpdotdev
  baseurl=https://releases.warp.dev/linux/rpm/stable
  enabled=1
  gpgcheck=1
  gpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'

  sudo dnf install -y warp-terminal
}

install_arch() {
  echo "Installing Warp (Pacman-based Linux)..."

  sudo sh -c "echo -e '\n[warpdotdev]\nServer = https://releases.warp.dev/linux/pacman/\$repo/\$arch' >> /etc/pacman.conf"
  sudo pacman-key -r "linux-maintainers@warp.dev"
  sudo pacman-key --lsign-key "linux-maintainers@warp.dev"

  sudo pacman -Sy --noconfirm warp-terminal
}

main() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    install_macos
  elif command_exists apt-get; then
    install_ubuntu
  elif command_exists dnf; then
    install_fedora
  elif command_exists pacman; then
    install_arch
  else
    echo "Unsupported system: no supported package manager found."
    exit 1
  fi

  echo "Warp installation complete."
}

main