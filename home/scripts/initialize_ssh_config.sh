#!/usr/bin/env bash
set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"

# Detect the OS
OS="$(uname)"
echo "🔍 Detected OS: $OS"

# Define platform-specific config blocks
MAC_CONFIG_BLOCK=$(cat <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
EOF
)

LINUX_CONFIG_BLOCK=$(cat <<'EOF'
Host *
  AddKeysToAgent yes
EOF
)

# Choose config block based on OS
case "$OS" in
  Darwin)
    CONFIG_BLOCK="$MAC_CONFIG_BLOCK"
    ;;
  Linux)
    CONFIG_BLOCK="$LINUX_CONFIG_BLOCK"
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

# Ensure ~/.ssh directory exists with secure permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Backup existing config if it exists
if [ -f "$SSH_CONFIG" ]; then
  BACKUP_PATH="$SSH_CONFIG.backup.$(date +%s)"
  echo "📦 Backing up existing ~/.ssh/config to $BACKUP_PATH"
  cp "$SSH_CONFIG" "$BACKUP_PATH"
fi

# Add config block only if not already present
if grep -q "IdentityFile ~/.ssh/id_ed25519" "$SSH_CONFIG" 2>/dev/null; then
  echo "⚠️ SSH config already contains IdentityFile entry. Please review manually if needed."
else
  echo "$CONFIG_BLOCK" >> "$SSH_CONFIG"
  echo "✅ SSH config initialized for $OS!"
  echo "Please use the scripts/create_ssh_key.sh script to create one or more ssh key pairs"
fi

# Set secure permissions
chmod 600 "$SSH_CONFIG"
