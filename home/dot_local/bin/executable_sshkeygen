#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, or pipe failure

# Prompt for the SSH key type, default to ed25519
read -p "Enter SSH key type (ed25519 or rsa) [default: ed25519]: " key_type
key_type=${key_type,,}  # convert to lowercase
key_type=${key_type:-ed25519}

# Validate the key type
if [[ "$key_type" != "ed25519" && "$key_type" != "rsa" ]]; then
  echo "❌ Unsupported key type: $key_type"
  echo "Only 'ed25519' and 'rsa' are supported."
  exit 1
fi

# Prompt for the key file path
read -p "Enter SSH key path (default: ~/.ssh/id_${key_type}): " key_path
key_path=${key_path:-~/.ssh/id_${key_type}}
key_path=$(eval echo "$key_path")  # Expand ~ to full path

# Prompt for a comment
read -p "Enter SSH key comment (e.g., your email or purpose): " key_comment

# Check if the key file already exists
if [ -f "$key_path" ]; then
  echo "❗ A key already exists at $key_path"
  read -p "Do you want to overwrite it? [y/N]: " overwrite
  if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
  fi
fi

# Ensure the directory for the key exists
mkdir -p "$(dirname "$key_path")"

# Generate the SSH key
if [ "$key_type" == "rsa" ]; then
  ssh-keygen -t rsa -b 4096 -f "$key_path" -C "$key_comment"
else
  ssh-keygen -t ed25519 -f "$key_path" -C "$key_comment"
fi

# Success message
echo "✅ SSH key generated:"
echo "  Private Key: $key_path"
echo "  Public Key:  ${key_path}.pub"

# Prompt whether to add the key to ssh-agent
read -p "Add this key to the ssh-agent? [Y/n]: " add_agent
add_agent=${add_agent,,}
add_agent=${add_agent:-y}

if [[ "$add_agent" == "y" || "$add_agent" == "yes" ]]; then
  echo "🚀 Adding key to ssh-agent..."

  # Start the ssh-agent if it's not already running
  eval "$(ssh-agent -s)"

  # macOS-specific: use Keychain integration if available
  if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain "$key_path"
    echo "✅ Key added to ssh-agent with macOS Keychain support"
  else
    ssh-add "$key_path"
    echo "✅ Key added to ssh-agent"
  fi
fi

# Try to copy public key to clipboard
echo "📋 Attempting to copy public key to clipboard..."

if command -v pbcopy &>/dev/null; then
  cat "${key_path}.pub" | pbcopy
  echo "✅ Public key copied to clipboard (macOS)"
elif command -v xclip &>/dev/null; then
  cat "${key_path}.pub" | xclip -selection clipboard
  echo "✅ Public key copied to clipboard (xclip - Linux)"
elif command -v xsel &>/dev/null; then
  cat "${key_path}.pub" | xsel --clipboard
  echo "✅ Public key copied to clipboard (xsel - Linux)"
elif command -v wl-copy &>/dev/null; then
  cat "${key_path}.pub" | wl-copy
  echo "✅ Public key copied to clipboard (Wayland)"
elif command -v clip.exe &>/dev/null; then
  cat "${key_path}.pub" | clip.exe
  echo "✅ Public key copied to clipboard (Windows/WSL)"
else
  echo "⚠️ Could not detect a clipboard utility."
  echo "🔓 Here's your public key:"
  echo "----------------------------------------"
  cat "${key_path}.pub"
  echo "----------------------------------------"
  echo "You can manually copy it from above."
fi
