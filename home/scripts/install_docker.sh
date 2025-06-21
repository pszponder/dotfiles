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
        ERRORS+=("❌ Failed: $description")
        print_status $RED "❌ Error occurred during: $description"
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
    print_status $YELLOW "🐧 Installing Docker on Ubuntu/Debian..."

    # Update package index
    run_with_error_handling "📦 Updating package index..." sudo apt-get update

    # Install prerequisites
    run_with_error_handling "📦 Installing prerequisites..." sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    run_with_error_handling "🔑 Adding Docker GPG key..." bash -c '
        sudo mkdir -m 0755 -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    '

    # Set up the repository
    run_with_error_handling "📋 Setting up Docker repository..." bash -c '
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    '

    # Update package index again
    run_with_error_handling "📦 Updating package index with Docker repo..." sudo apt-get update

    # Install Docker Engine
    run_with_error_handling "🐳 Installing Docker Engine..." sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}

# Function to install Docker on Fedora
install_docker_fedora() {
    print_status $YELLOW "🐧 Installing Docker on Fedora..."

    # Update package index
    run_with_error_handling "📦 Updating package index..." sudo dnf update -y

    # Install prerequisites
    run_with_error_handling "📦 Installing prerequisites..." sudo dnf install -y \
        dnf-plugins-core \
        curl

    # Add Docker repository
    run_with_error_handling "📋 Adding Docker repository..." sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo

    # Install Docker Engine
    run_with_error_handling "🐳 Installing Docker Engine..." sudo dnf install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}

# Function to get latest Docker Desktop download URLs
get_latest_docker_desktop_urls() {
    print_status $BLUE "🔍 Detecting latest Docker Desktop version..."

    # Try to get the latest version from Docker's API or fallback to direct URLs
    if command -v curl &>/dev/null; then
        # Attempt to get latest version (this may not always work due to API changes)
        LATEST_VERSION=$(curl -s "https://api.github.com/repos/docker/desktop-linux/releases/latest" | grep -Po '"tag_name": "v\K[^"]*' 2>/dev/null || echo "")

        if [ -n "$LATEST_VERSION" ]; then
            print_status $GREEN "📦 Latest version detected: $LATEST_VERSION"
            UBUNTU_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-${LATEST_VERSION}-amd64.deb"
            FEDORA_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-${LATEST_VERSION}-x86_64.rpm"
        else
            print_status $YELLOW "⚠️  Could not detect version, using latest release URLs"
            # Fallback to latest URLs (these always point to the newest version)
            UBUNTU_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"
            FEDORA_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm"
        fi
    else
        # Fallback URLs if curl is not available
        UBUNTU_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"
        FEDORA_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm"
    fi
}

# Function to install Docker Desktop
install_docker_desktop() {
    local distro=$1
    print_status $YELLOW "🖥️  Installing Docker Desktop (latest version)..."

    # Get latest URLs
    get_latest_docker_desktop_urls

    case $distro in
        ubuntu|debian)
            # Download and install Docker Desktop for Ubuntu (latest)
            run_with_error_handling "📥 Downloading latest Docker Desktop for Ubuntu..." \
                wget -O /tmp/docker-desktop.deb "$UBUNTU_URL"

            run_with_error_handling "📦 Installing Docker Desktop..." \
                sudo apt-get install -y /tmp/docker-desktop.deb
            ;;
        fedora)
            # Download and install Docker Desktop for Fedora (latest)
            run_with_error_handling "📥 Downloading latest Docker Desktop for Fedora..." \
                wget -O /tmp/docker-desktop.rpm "$FEDORA_URL"

            run_with_error_handling "📦 Installing Docker Desktop..." \
                sudo dnf install -y /tmp/docker-desktop.rpm
            ;;
        *)
            ERRORS+=("❌ Docker Desktop installation not supported for $distro")
            print_status $RED "❌ Docker Desktop installation not supported for $distro"
            return 1
            ;;
    esac

    # Clean up downloaded files
    rm -f /tmp/docker-desktop.deb /tmp/docker-desktop.rpm 2>/dev/null || true
}

# Function to configure Docker
configure_docker() {
    print_status $YELLOW "⚙️  Configuring Docker..."

    # Add user to docker group
    run_with_error_handling "👤 Adding user to docker group..." sudo usermod -aG docker $USER

    # Enable and start Docker service
    run_with_error_handling "🚀 Enabling Docker service..." sudo systemctl enable docker
    run_with_error_handling "🚀 Starting Docker service..." sudo systemctl start docker

    # Test Docker installation
    run_with_error_handling "🧪 Testing Docker installation..." sudo docker run --rm hello-world
}

# Function to display post-installation instructions
show_post_install_instructions() {
    print_status $GREEN "✅ Installation completed!"
    echo ""
    print_status $BLUE "📋 Post-installation steps:"
    echo "1. Log out and log back in (or restart) for group changes to take effect"
    echo "2. After logging back in, test Docker with: docker run hello-world"
    echo "3. Start Docker Desktop from your applications menu or run: systemctl --user start docker-desktop"
    echo ""
    print_status $BLUE "🔧 Useful commands:"
    echo "• Check Docker version: docker --version"
    echo "• Check Docker status: systemctl status docker"
    echo "• Start Docker Desktop: systemctl --user start docker-desktop"
    echo "• Stop Docker Desktop: systemctl --user stop docker-desktop"
}

# Main installation function
main() {
    print_status $GREEN "🐳 Docker and Docker Desktop Installation Script"
    echo "=================================================="
    echo ""

    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_status $RED "❌ Please don't run this script as root!"
        echo "The script will use sudo when needed."
        exit 1
    fi

    # Detect distribution
    DISTRO=$(detect_distro)
    print_status $BLUE "🔍 Detected distribution: $DISTRO"

    # Check if Docker is already installed
    if command -v docker &> /dev/null; then
        print_status $YELLOW "⚠️  Docker is already installed!"
        echo "Current version: $(docker --version)"
        read -p "Do you want to continue and install Docker Desktop? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status $BLUE "👋 Installation cancelled."
            exit 0
        fi
        DOCKER_ALREADY_INSTALLED=true
    else
        DOCKER_ALREADY_INSTALLED=false
    fi

    # Install Docker based on distribution
    if [ "$DOCKER_ALREADY_INSTALLED" = false ]; then
        case $DISTRO in
            ubuntu|debian)
                install_docker_ubuntu
                ;;
            fedora)
                install_docker_fedora
                ;;
            *)
                print_status $RED "❌ Unsupported distribution: $DISTRO"
                echo "This script supports Ubuntu, Debian, and Fedora."
                exit 1
                ;;
        esac

        # Configure Docker
        configure_docker
    fi

    # Install Docker Desktop
    install_docker_desktop $DISTRO

    # Show results
    echo ""
    if [ ${#ERRORS[@]} -eq 0 ]; then
        show_post_install_instructions
        exit 0
    else
        print_status $YELLOW "⚠️  Installation completed with some errors:"
        printf '%s\n' "${ERRORS[@]}"
        echo ""
        print_status $BLUE "🔍 Please review the errors above and fix them manually if needed."
        show_post_install_instructions
        exit 1
    fi
}

# Run the main function
main "$@"