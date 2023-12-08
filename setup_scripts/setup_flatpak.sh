#!/usr/bin/env bash

echo "Checking if Flatpak is installed..."

# Check if Flatpak is already installed
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak is not installed. Installing it..."

    # Install Flatpak
    sudo apt install flatpak

    # Add Flathub repository to Flatpak
    echo "Adding Flathub repository to Flatpak..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    echo "Flatpak has been installed and Flathub repository added."
else
    echo "Flatpak is already installed."
fi
