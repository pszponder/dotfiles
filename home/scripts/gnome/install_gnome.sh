#!/usr/bin/env bash

set -e

echo "🖥️ Starting GNOME setup..."

# Install GNOME extensions
"$(dirname "$0")/install_gnome_extensions.sh"

# TODO: Configure GNOME Hotkeys
"$(dirname "$0")/configure_gnome_hotkeys.sh"

# Configure GNOME settings
"$(dirname "$0")/configure_gnome_settings.sh"

echo "✅ GNOME setup complete."
