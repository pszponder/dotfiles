#!/usr/bin/env bash

# Set the GitHub API URL for WezTerm releases
GITHUB_API_URL="https://api.github.com/repos/wez/wezterm/releases/latest"

# Use curl to fetch the latest release data from GitHub API
LATEST_RELEASE=$(curl -s $GITHUB_API_URL)

# Use jq to parse the download URL for the latest AppImage from the release assets
APPIMAGE_URL=$(echo $LATEST_RELEASE | jq -r '.assets[] | select(.name | endswith(".AppImage")) | .browser_download_url' | head -1)

# Exit if the AppImage URL couldn't be found
if [ -z "$APPIMAGE_URL" ] || [ "$APPIMAGE_URL" = "null" ]; then
    echo "Failed to find the AppImage URL for the latest WezTerm release."
    exit 1
fi

# Extract the filename from the URL
FILENAME=$(basename $APPIMAGE_URL)

# Download the AppImage
curl -LO $APPIMAGE_URL

# Make the AppImage executable
chmod +x $FILENAME

# Create a bin directory in the home folder if it doesn't exist
mkdir -p ~/bin

# Move the AppImage to the bin directory
mv $FILENAME ~/bin/wezterm

# Create icons directory if it doesn't exist
mkdir -p ~/.local/share/icons

# Copy the WezTerm icon to the icons directory
cp ./assets/wezterm.png ~/.local/share/icons/

# Check if the .desktop file already exists
DESKTOP_FILE=~/.local/share/applications/wezterm.desktop
if [ ! -f "$DESKTOP_FILE" ]; then
    # Create the .desktop file
    echo "[Desktop Entry]
Name=WezTerm
Comment=Wez's Terminal Emulator
Keywords=shell;prompt;command;commandline;cmd;
Icon=$HOME/.local/share/icons/wezterm.png
StartupWMClass=org.wezfurlong.wezterm
TryExec=wezterm
Exec=wezterm start --cwd .
Type=Application
Categories=System;TerminalEmulator;Utility;
Terminal=false" > $DESKTOP_FILE

    # Make the .desktop file executable
    chmod +x $DESKTOP_FILE

    echo "WezTerm .desktop file created."
else
    echo "WezTerm .desktop file already exists."
fi

echo "WezTerm installation complete."