#!/usr/bin/env bash
set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"

# Function to detect the OS
detect_os() {
  uname
}

# Function to get the config block based on OS
get_config_block() {
  local os="$1"

  case "$os" in
    Darwin)
      cat <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
EOF
      ;;
    Linux)
      cat <<'EOF'
Host *
  AddKeysToAgent yes
EOF
      ;;
    *)
      echo "❌ Unsupported OS: $os" >&2
      exit 1
      ;;
  esac
}

# Function to ensure the ~/.ssh directory exists with secure permissions
ensure_ssh_directory() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
}

# Function to backup existing SSH config if it exists
backup_ssh_config() {
  if [ -f "$SSH_CONFIG" ]; then
    local backup_path="$SSH_CONFIG.bak.$(date +%s)"
    echo "📦 Backing up existing ~/.ssh/config to $backup_path"
    cp "$SSH_CONFIG" "$backup_path"
  fi
}

# Function to add the config block if it is not already present
update_ssh_config() {
  local config_block="$1"

  # Check if the first line of the config block is already in the file
  local first_line
  first_line="$(echo "$config_block" | head -n 1)"

  if grep -qF "$first_line" "$SSH_CONFIG" 2>/dev/null; then
    echo "⚠️ SSH config already contains settings for '$first_line'. Please review manually if needed."
  else
    echo "$config_block" >> "$SSH_CONFIG"
    echo "✅ SSH config updated!"
    echo "Please use the ~/.local/bin/sshkeygen.sh script to create one or more SSH key pairs."
  fi

  chmod 600 "$SSH_CONFIG"
}

# Main function
main() {
  local os
  os="$(detect_os)"
  echo "🔍 Detected OS: $os"

  local config_block
  config_block="$(get_config_block "$os")"

  ensure_ssh_directory
  backup_ssh_config
  update_ssh_config "$config_block"
}

# Run the main function
main
