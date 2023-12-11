#!/usr/bin/env bash

# Script to configure global Git settings

# Prompt the user for their name, email address
# Should user GitHub username for user_name
# Should use GitHub's no-reply email address for user_email
read -p "Enter your Git user name: " user_name
read -p "Enter your Git email address: " user_email

# Configure Git with the provided user name, email address
git config --global user.name "$user_name"
git config --global user.email "$user_email"

# Display the configuration for confirmation
echo "Git global configuration updated:"
git config --list --global
