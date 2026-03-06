#!/usr/bin/env bash

set -euo pipefail

echo "Attempting to setup Gnome Keyring..."

# ---------------------------------------------------------------------------
# 1. Check if a D-Bus secrets service is already available
# ---------------------------------------------------------------------------
if command -v dbus-send &>/dev/null; then
    if dbus-send --session --dest=org.freedesktop.DBus --type=method_call \
        --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListActivatableNames 2>/dev/null \
        | grep -q "org.freedesktop.secrets"; then
        echo "ℹ️  A secrets service (org.freedesktop.secrets) is already available, skipping."
        exit 0
    fi
fi

# Also skip if gnome-keyring-daemon is already installed and PAM is configured
if command -v gnome-keyring-daemon &>/dev/null; then
    echo "ℹ️  gnome-keyring-daemon is already installed."
    # We'll still fall through to verify PAM configuration below
fi

# ---------------------------------------------------------------------------
# 2. Detect the Linux distribution family
# ---------------------------------------------------------------------------
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        echo "${ID:-unknown}"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    elif [[ -f /etc/redhat-release ]]; then
        echo "rhel"
    else
        echo "unknown"
    fi
}

# Map derivative distros to their parent family
distro_family() {
    local distro="$1"
    case "$distro" in
        arch|cachyos|endeavouros|manjaro|garuda|artix)
            echo "arch" ;;
        debian|ubuntu|pop|linuxmint|elementary|zorin|kali)
            echo "debian" ;;
        fedora|nobara)
            echo "fedora" ;;
        rhel|centos|rocky|alma|ol)
            echo "rhel" ;;
        opensuse*|sles)
            echo "suse" ;;
        void)
            echo "void" ;;
        alpine)
            echo "alpine" ;;
        *)
            echo "unknown" ;;
    esac
}

DISTRO="$(detect_distro)"
FAMILY="$(distro_family "$DISTRO")"

echo "==> Detected distro: $DISTRO (family: $FAMILY)"

if [[ "$FAMILY" == "unknown" ]]; then
    echo "Error: Unsupported distribution '$DISTRO'. Please install gnome-keyring and libsecret manually."
    exit 1
fi

# ---------------------------------------------------------------------------
# 3. Install gnome-keyring and libsecret
# ---------------------------------------------------------------------------
install_packages() {
    local family="$1"
    case "$family" in
        arch)
            echo "==> Installing via pacman..."
            sudo pacman -S --needed gnome-keyring libsecret
            ;;
        debian)
            echo "==> Installing via apt..."
            sudo apt update
            sudo apt install -y gnome-keyring libsecret-1-0
            ;;
        fedora)
            echo "==> Installing via dnf..."
            sudo dnf install -y gnome-keyring libsecret
            ;;
        rhel)
            echo "==> Installing via dnf/yum..."
            if command -v dnf &>/dev/null; then
                sudo dnf install -y gnome-keyring libsecret
            else
                sudo yum install -y gnome-keyring libsecret
            fi
            ;;
        suse)
            echo "==> Installing via zypper..."
            sudo zypper install -y gnome-keyring libsecret
            ;;
        void)
            echo "==> Installing via xbps..."
            sudo xbps-install -Sy gnome-keyring libsecret
            ;;
        alpine)
            echo "==> Installing via apk..."
            sudo apk add gnome-keyring libsecret
            ;;
    esac
}

if ! command -v gnome-keyring-daemon &>/dev/null; then
    install_packages "$FAMILY"
else
    echo "ℹ️  gnome-keyring packages already installed."
fi

# ---------------------------------------------------------------------------
# 4. Configure PAM for gnome-keyring auto-unlock on login
# ---------------------------------------------------------------------------

# Debian/Ubuntu handle PAM config automatically via pam-auth-update.
# Other distros need manual PAM configuration.
if [[ "$FAMILY" == "debian" ]]; then
    echo "ℹ️  Debian-based systems configure PAM automatically via pam-auth-update."
    echo "==> Running pam-auth-update to ensure gnome-keyring is enabled..."
    sudo pam-auth-update --enable gnome-keyring
else
    # Determine the correct PAM file for the distro family
    case "$FAMILY" in
        arch)    PAM_FILE="/etc/pam.d/system-local-login" ;;
        *)       PAM_FILE="/etc/pam.d/login" ;;
    esac

    echo "==> Configuring PAM in $PAM_FILE..."

    if [[ ! -f "$PAM_FILE" ]]; then
        echo "Error: $PAM_FILE not found."
        exit 1
    fi

    # Skip if already fully configured
    if grep -q "^auth.*pam_gnome_keyring\.so" "$PAM_FILE" \
        && grep -q "pam_gnome_keyring\.so auto_start" "$PAM_FILE"; then
        echo "ℹ️  PAM is already configured for gnome-keyring, skipping."
    else
        TIMESTAMP="$(date +%Y%m%d%H%M%S)"
        BACKUP_FILE="${PAM_FILE}.bak.${TIMESTAMP}"

        echo "==> Creating backup at $BACKUP_FILE"
        sudo cp "$PAM_FILE" "$BACKUP_FILE"

        AUTH_LINE="auth      optional    pam_gnome_keyring.so"
        SESSION_LINE="session   optional    pam_gnome_keyring.so auto_start"

        if ! grep -q "^auth.*pam_gnome_keyring\.so" "$PAM_FILE"; then
            echo "Adding auth hook..."
            echo "$AUTH_LINE" | sudo tee -a "$PAM_FILE" > /dev/null
        else
            echo "Auth hook already present."
        fi

        if ! grep -q "pam_gnome_keyring\.so auto_start" "$PAM_FILE"; then
            echo "Adding session auto_start hook..."
            echo "$SESSION_LINE" | sudo tee -a "$PAM_FILE" > /dev/null
        else
            echo "Session hook already present."
        fi
    fi
fi

echo
echo "==> Done."
echo "Log out completely and log back in."
echo "After login, verify with:"
echo "    echo \$SSH_AUTH_SOCK"
