#!/usr/bin/env bash
set -uo pipefail

# Array to collect error messages
declare -a ERRORS=()

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to run a command and capture errors
run_with_error_handling() {
    local description="$1"
    shift
    print_status $BLUE "$description"

    if ! "$@"; then
        ERRORS+=("\u274C Failed: $description")
        print_status $RED "\u274C Error occurred during: $description"
        return 1
    fi
    return 0
}

# Function to detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif type lsb_release >/dev/null 2>&1; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Function to install Docker on Ubuntu/Debian
install_docker_ubuntu() {
    print_status $YELLOW "\U0001F427 Installing Docker on Ubuntu/Debian..."

    run_with_error_handling "\U0001F4E6 Updating package index..." sudo apt-get update

    run_with_error_handling "\U0001F4E6 Installing prerequisites..." sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        uidmap \
        dbus-user-session

    run_with_error_handling "\U0001F511 Adding Docker GPG key..." bash -c '
        sudo mkdir -m 0755 -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    '

    run_with_error_handling "\U0001F4CB Setting up Docker repository..." bash -c '
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    '

    run_with_error_handling "\U0001F4E6 Updating package index with Docker repo..." sudo apt-get update

    run_with_error_handling "\U0001F433 Installing Docker Engine..." sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}

# Function to install Docker on Fedora
install_docker_fedora() {
    print_status $YELLOW "\U0001F427 Installing Docker on Fedora..."

    run_with_error_handling "\U0001F4E6 Updating package index..." sudo dnf update -y

    run_with_error_handling "\U0001F4E6 Installing prerequisites..." sudo dnf install -y \
        dnf-plugins-core \
        curl \
        uidmap \
        dbus-user-session

    run_with_error_handling "\U0001F4CB Adding Docker repository..." sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo

    run_with_error_handling "\U0001F433 Installing Docker Engine..." sudo dnf install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}

get_latest_docker_desktop_urls() {
    print_status $BLUE "\U0001F50D Detecting latest Docker Desktop version..."

    if command -v curl &>/dev/null; then
        LATEST_VERSION=$(curl -s "https://api.github.com/repos/docker/desktop-linux/releases/latest" |
                         grep -Po '"tag_name": "v\K[^\"]*' 2>/dev/null || echo "")

        if [ -n "$LATEST_VERSION" ]; then
            print_status $GREEN "\U0001F4E6 Latest version detected: $LATEST_VERSION"
            UBUNTU_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-${LATEST_VERSION}-amd64.deb"
            FEDORA_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-${LATEST_VERSION}-x86_64.rpm"
        else
            print_status $YELLOW "\u26A0\uFE0F Could not detect version, using latest stable URLs"
            UBUNTU_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"
            FEDORA_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm"
        fi
    fi
}

install_docker_desktop() {
    local distro=$1
    print_status $YELLOW "\U0001F5A5\uFE0F Installing Docker Desktop (latest version)..."

    get_latest_docker_desktop_urls

    case $distro in
        ubuntu|debian)
            run_with_error_handling "\U0001F4E5 Downloading Docker Desktop for Ubuntu..." \
                wget -O /tmp/docker-desktop.deb "$UBUNTU_URL"

            run_with_error_handling "\U0001F4E6 Installing Docker Desktop..." \
                sudo apt-get install -y /tmp/docker-desktop.deb

            systemctl --user enable docker-desktop
            systemctl --user start docker-desktop
            ;;
        fedora)
            run_with_error_handling "\U0001F4E5 Downloading Docker Desktop for Fedora..." \
                wget -O /tmp/docker-desktop.rpm "$FEDORA_URL"

            run_with_error_handling "\U0001F4E6 Installing Docker Desktop..." \
                sudo dnf install -y /tmp/docker-desktop.rpm

            systemctl --user enable docker-desktop
            systemctl --user start docker-desktop
            ;;
        *)
            ERRORS+=("\u274C Docker Desktop installation not supported for $distro")
            print_status $RED "\u274C Docker Desktop installation not supported for $distro"
            return 1
            ;;
    esac

    rm -f /tmp/docker-desktop.deb /tmp/docker-desktop.rpm 2>/dev/null || true
}

configure_docker() {
    print_status $YELLOW "\u2699\uFE0F Configuring Docker..."
    run_with_error_handling "\U0001F464 Adding user to docker group..." sudo usermod -aG docker "$USER"
    run_with_error_handling "\U0001F680 Enabling Docker service..." sudo systemctl enable docker
    run_with_error_handling "\U0001F680 Starting Docker service..." sudo systemctl start docker
    run_with_error_handling "\U0001F52A Testing Docker installation..." sudo docker run --rm hello-world
}

show_post_install_instructions() {
    print_status $GREEN "\u2705 Installation completed!"
    echo
    print_status $BLUE "\U0001F4CB Post-installation steps:"
    echo "1. Log out and log back in for Docker group changes to apply"
    echo "2. Run: docker run hello-world"
    echo "3. Start Docker Desktop (if needed): systemctl --user start docker-desktop"
    echo
    print_status $BLUE "\u2699\uFE0F Useful commands:"
    echo "- docker --version"
    echo "- systemctl status docker"
    echo "- systemctl --user start docker-desktop"
    echo "- systemctl --user stop docker-desktop"
}

main() {
    print_status $GREEN "\U0001F433 Docker and Docker Desktop Installation Script"
    echo "=================================================="

    if [ "$EUID" -eq 0 ]; then
        print_status $RED "\u274C Do not run this script as root!"
        exit 1
    fi

    DISTRO=$(detect_distro)
    print_status $BLUE "\U0001F50D Detected distribution: $DISTRO"

    if command -v docker &> /dev/null; then
        print_status $YELLOW "\u26A0\uFE0F Docker is already installed!"
        echo "Version: $(docker --version)"
        read -p "Install Docker Desktop anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status $BLUE "\U0001F44B Installation cancelled."
            exit 0
        fi
        DOCKER_ALREADY_INSTALLED=true
    else
        DOCKER_ALREADY_INSTALLED=false
    fi

    if [ "$DOCKER_ALREADY_INSTALLED" = false ]; then
        case $DISTRO in
            ubuntu|debian)
                install_docker_ubuntu
                ;;
            fedora)
                install_docker_fedora
                ;;
            *)
                print_status $RED "\u274C Unsupported distro: $DISTRO"
                exit 1
                ;;
        esac
        configure_docker
    fi

    install_docker_desktop "$DISTRO"

    echo
    if [ ${#ERRORS[@]} -eq 0 ]; then
        show_post_install_instructions
        exit 0
    else
        print_status $YELLOW "\u26A0\uFE0F Installation completed with errors:"
        printf '%s\n' "${ERRORS[@]}"
        show_post_install_instructions
        exit 1
    fi
}

main "$@"
