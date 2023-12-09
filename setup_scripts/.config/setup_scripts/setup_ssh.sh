#!/usr/bin/env bash

# Define the SSH directory path
SSH_DIR="$HOME/.ssh"

# Check if the SSH directory exists
if [ ! -d "$SSH_DIR" ]; then
    echo "Creating SSH directory..."
    mkdir -p "$SSH_DIR"

    # Set the permissions to read, write, and execute only for the user
    chmod 700 "$SSH_DIR"
    echo "$SSH_DIR created and permissions set."
else
    echo "SSH directory already exists."
fi

# Function to create SSH key and add to the agent
create_and_add_key() {
    local key_dir=$1
    local key_comment=$2
    local key_name=$3

    # Create the directory if it doesn't exist
    mkdir -p "$SSH_DIR/$key_dir"

    # Generate the SSH key
    ssh-keygen -t rsa -b 4096 -C "$key_comment" -f "$key_dir/$key_name"

    # Add the key to the ssh-agent
    ssh-add "$SSH_DIR/$key_dir/$key_name"
}

# Create and add ssh keys
echo "Creating and adding SSH keys..."
create_and_add_key personal "Personal Key" id_rsa_personal
create_and_add_key work "Work Key" id_rsa_work
create_and_add_key github "GitHub Key" id_rsa_github

echo "All keys created and added to the SSH agent."
