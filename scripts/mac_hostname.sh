#!/bin/bash

# Script to update macOS hostname
# Prompts user for a new hostname and updates the system

set -e

# Source utility files if they exist
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "$SCRIPT_DIR/utils_logging.sh" ]] && source "$SCRIPT_DIR/utils_logging.sh"

# Function to get current hostname
get_current_hostname() {
    scutil --get ComputerName
}

# Function to set hostname
set_hostname() {
    local new_hostname="$1"

    # Set all three hostname components on macOS
    sudo scutil --set ComputerName "$new_hostname"
    sudo scutil --set HostName "$new_hostname"
    sudo scutil --set LocalHostName "$new_hostname"
}

# Main
main() {
    local current_hostname
    current_hostname=$(get_current_hostname)

    echo "Current hostname: $current_hostname"
    echo ""
    read -p "Enter new hostname: " new_hostname

    # Validate input
    if [[ -z "$new_hostname" ]]; then
        echo "Error: Hostname cannot be empty"
        exit 1
    fi

    # Check for valid hostname characters (alphanumeric and hyphens)
    if ! [[ "$new_hostname" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo "Error: Hostname can only contain letters, numbers, and hyphens"
        exit 1
    fi

    # Check hostname length (max 63 characters)
    if [[ ${#new_hostname} -gt 63 ]]; then
        echo "Error: Hostname must be 63 characters or less"
        exit 1
    fi

    echo ""
    echo "Setting hostname to: $new_hostname"

    set_hostname "$new_hostname"

    echo "Hostname updated successfully!"
    echo "New hostname: $(get_current_hostname)"
    echo ""
    echo "Note: You may need to logout or restart your computer for all changes to take effect."
    read -p "Would you like to logout now? (y/n): " logout_choice

    if [[ "$logout_choice" =~ ^[Yy]$ ]]; then
        echo "Logging out..."
        osascript -e 'tell app "System Events" to log out'
    else
        echo "Please remember to logout or restart your computer when ready."
    fi
}

main "$@"
