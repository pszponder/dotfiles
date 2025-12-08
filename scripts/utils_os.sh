# Detect OS type: "macos", "arch", "debian", "fedora", "ublue", or "unknown"
get_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check for specific Linux distributions
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            case $ID in
                arch|manjaro|endeavouros)
                    echo "arch"
                    ;;
                debian|ubuntu|pop|elementary|linuxmint)
                    echo "debian"
                    ;;
                fedora)
                    # Check if it's Universal Blue (ublue)
                    if [[ -f /etc/os-release ]] && grep -q "ublue" /etc/os-release; then
                        echo "ublue"
                    else
                        echo "fedora"
                    fi
                    ;;
                *)
                    # Check for other common distributions
                    if command -v pacman &> /dev/null; then
                        echo "arch"
                    elif command -v apt &> /dev/null; then
                        echo "debian"
                    elif command -v dnf &> /dev/null; then
                        echo "fedora"
                    else
                        echo "linux"
                    fi
                    ;;
            esac
        else
            # Fallback detection based on package managers
            if command -v pacman &> /dev/null; then
                echo "arch"
            elif command -v apt &> /dev/null; then
                echo "debian"
            elif command -v dnf &> /dev/null; then
                echo "fedora"
            else
                echo "linux"
            fi
        fi
    else
        echo "unknown"
    fi
}