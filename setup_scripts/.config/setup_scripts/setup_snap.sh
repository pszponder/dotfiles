#!/usr/bin/env bash

echo "Checking if Snap is installed..."

# Check if Snap is already installed
if ! command -v snap &> /dev/null; then
    echo "Snap is not installed. Installing it..."

    # Install Snap
    sudo apt install snapd

    echo "Snap has been installed."
else
    echo "Snap is already installed."
fi
