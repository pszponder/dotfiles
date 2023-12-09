#!/usr/bin/env bash

# Define the target directory for stowing (usually the home directory)
TARGET_DIR="$HOME"

# Loop through each directory in the dotfiles directory
for dir in */ ; do
	# Check if the directory is not .git
	if [[ "$dir" != ".git/" ]]; then
		# Stow the directory
		stow -v --target="$TARGET_DIR" "$dir"
	fi
done
