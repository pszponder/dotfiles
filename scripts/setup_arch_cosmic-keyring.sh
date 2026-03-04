#!/usr/bin/env bash

set -euo pipefail

echo "Attempting to setup Gnome Keyring on Arch Linux..."

# Ensure we're on Arch Linux
if [[ ! -f /etc/arch-release ]]; then
    echo "Error: This script is intended for Arch Linux only."
    exit 1
fi

PAM_FILE="/etc/pam.d/system-local-login"

# Skip if gnome-keyring is already fully configured
if pacman -Qi gnome-keyring &>/dev/null \
    && [[ -f "$PAM_FILE" ]] \
    && grep -q "^auth.*pam_gnome_keyring\.so" "$PAM_FILE" \
    && grep -q "pam_gnome_keyring\.so auto_start" "$PAM_FILE"; then
    echo "ℹ️ gnome-keyring is already configured, skipping."
    exit 0
fi
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_FILE="/etc/pam.d/system-local-login.bak.${TIMESTAMP}"

echo "==> Installing required packages (if missing)..."
sudo pacman -S --needed gnome-keyring libsecret

echo "==> Verifying PAM file exists..."
if [[ ! -f "$PAM_FILE" ]]; then
    echo "Error: $PAM_FILE not found."
    exit 1
fi

echo "==> Creating backup at $BACKUP_FILE"
sudo cp "$PAM_FILE" "$BACKUP_FILE"

AUTH_LINE="auth      optional    pam_gnome_keyring.so"
SESSION_LINE="session   optional    pam_gnome_keyring.so auto_start"

echo "==> Ensuring pam_gnome_keyring is configured..."

# Add auth line if missing
if ! grep -q "^auth.*pam_gnome_keyring\.so" "$PAM_FILE"; then
    echo "Adding auth hook..."
    echo "$AUTH_LINE" | sudo tee -a "$PAM_FILE" > /dev/null
else
    echo "Auth hook already present."
fi

# Add session line if missing
if ! grep -q "pam_gnome_keyring\.so auto_start" "$PAM_FILE"; then
    echo "Adding session auto_start hook..."
    echo "$SESSION_LINE" | sudo tee -a "$PAM_FILE" > /dev/null
else
    echo "Session hook already present."
fi

echo
echo "==> Done."
echo "Log out completely and log back in."
echo "After login, verify with:"
echo "    echo \$SSH_AUTH_SOCK"