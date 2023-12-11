#!/usr/bin/env bash

# Prompt the user for their Git username
read -p "Enter your Git username: " username

# Prompt the user for their Git email
read -p "Enter your Git email: " email

# Path to the config-personal file
config_personal=~/.config/git/config-personal

# Create or overwrite the config-personal file with user input
cat <<EOF > "$config_personal"
[user]
	name = $username
	email = $email
EOF

echo "Config-personal file has been created or updated with the provided user information."
