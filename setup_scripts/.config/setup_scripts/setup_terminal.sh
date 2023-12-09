#!/usr/bin/env bash

# Configure Gnome Terminal

# https://github.com/catppuccin/gnome-terminal
echo "Installing Catppuccin Theme for Gnome Terminal..."
curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -

<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match target="pattern">
        <test qual="any" name="family">
            <string>YourPrimaryFontName</string>
        </test>
        <edit name="family" mode="append" binding="strong">
            <string>YourFallbackFontName</string>
        </edit>
    </match>
</fontconfig>