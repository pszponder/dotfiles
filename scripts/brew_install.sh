#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, or pipe failure

# brew_install.sh - Install Homebrew on macOS or Linux

# Source shared logging utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils_logging.sh"
source "$SCRIPT_DIR/utils_os.sh"

check_brew_installed() {
    if command -v brew &> /dev/null; then
        log_success "Homebrew is already installed: $(brew --version | head -n 1)"
        exit 0
    fi
}

install_dependencies() {
    local os_type=$(get_os)
    log_info "Installing Homebrew dependencies for $os_type..."

    case $os_type in
        macos)
            log_info "macOS detected - Homebrew dependencies should already be available"
            ;;
        debian)
            log_info "Installing necessary Debian/Ubuntu dependencies..."
            sudo apt-get update
            sudo apt-get install -y build-essential procps curl file git
            ;;
        fedora)
            log_info "Installing necessary Fedora dependencies..."
            sudo dnf group install -y development-tools
            sudo dnf install -y procps-ng curl file git
            ;;
        arch)
            log_info "Installing necessary Arch Linux dependencies..."
            sudo pacman -Sy --needed base-devel procps-ng curl file git
            ;;
        *)
            log_error "Unsupported OS: $os_type. Please install dependencies manually."
            exit 1
            ;;
    esac

    log_success "Dependencies installed successfully"
}

install_homebrew() {
    log_info "Installing Homebrew..."

    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        log_success "Homebrew installation completed successfully"
    else
        log_error "Homebrew installation failed"
        exit 1
    fi
}

main() {
    log_info "Starting Homebrew installation process..."
    check_brew_installed
    install_dependencies
    install_homebrew
}

main "$@"