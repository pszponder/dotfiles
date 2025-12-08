#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, or pipe failure

# brew_sync.sh - Sync Homebrew packages and install from Brewfile

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Homebrew is installed
check_brew() {
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    log_success "Homebrew is installed: $(brew --version | head -n 1)"
}

# Update Homebrew and upgrade packages
update_brew() {
    log_info "Updating Homebrew..."
    brew update

    log_info "Upgrading installed packages..."
    brew upgrade

    log_info "Cleaning up old versions..."
    brew cleanup

    log_success "Homebrew update complete"
}

# Install packages from Brewfile
install_from_brewfile() {
    local brewfile_path="$1"

    if [[ ! -f "$brewfile_path" ]]; then
        log_error "Brewfile not found at: $brewfile_path"
        exit 1
    fi

    log_info "Installing packages from Brewfile: $brewfile_path"
    brew bundle --file="$brewfile_path"

    log_success "Brewfile installation complete"
}

# Check for outdated packages
check_outdated() {
    log_info "Checking for outdated packages..."
    local outdated=$(brew outdated)

    if [[ -z "$outdated" ]]; then
        log_success "All packages are up to date"
    else
        log_warning "Outdated packages found:"
        echo "$outdated"
    fi
}

# Main function
main() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local brewfile_path="$script_dir/Brewfile"

    log_info "Starting Homebrew sync..."

    # Check if Homebrew is installed
    check_brew

    # Update Homebrew and packages
    update_brew

    # Install from Brewfile
    install_from_brewfile "$brewfile_path"

    # Check for any remaining outdated packages
    check_outdated

    log_success "Homebrew sync completed successfully!"
}

# Run main function
main "$@"
