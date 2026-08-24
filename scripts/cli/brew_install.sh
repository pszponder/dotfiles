#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if command -v brew >/dev/null 2>&1; then
  log_info 'Homebrew already installed, skipping'
  exit 0
fi

case "$(uname -s)" in
  Darwin)
    if ! xcode-select -p >/dev/null 2>&1; then
      xcode-select --install
      until xcode-select -p >/dev/null 2>&1; do sleep 5; done
    fi
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update -y
      sudo apt-get install -y build-essential procps curl file git
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf group install -y development-tools
      sudo dnf install -y procps-ng curl file git
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm --needed base-devel procps-ng curl file git
    else
      log_warn 'Unknown package manager; Homebrew prerequisites were not installed'
    fi
    ;;
esac

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
log_success 'Homebrew installed'
