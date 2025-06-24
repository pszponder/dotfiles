#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
  local color="$1"
  local message="$2"
  echo -e "${color}${message}${NC}"
}

# Function to switch chezmoi repo to SSH
switch_chezmoi_to_ssh() {
  local chezmoi_repo_dir="$HOME/.local/share/chezmoi"
  local ssh_url="git@github.com:pszponder/dotfiles.git"
  local https_url="https://github.com/pszponder/dotfiles.git"

  if [ -d "$chezmoi_repo_dir/.git" ]; then
    cd "$chezmoi_repo_dir"

    local current_url
    current_url=$(git remote get-url origin)

    if [[ "$current_url" == "$https_url" ]]; then
      print_status "$YELLOW" "🔄 Switching chezmoi dotfiles repo from HTTPS to SSH..."
      git remote set-url origin "$ssh_url"
      print_status "$GREEN" "✅ Remote URL updated to SSH: $ssh_url"
    else
      print_status "$GREEN" "✅ chezmoi remote is already using SSH or a custom URL."
    fi
  else
    print_status "$RED" "❌ chezmoi git directory not found. Has it been initialized?"
    exit 1
  fi
}

# Main logic
print_status "$BLUE" "🚀 Initializing chezmoi with HTTPS..."
chezmoi init --apply pszponder

switch_chezmoi_to_ssh

print_status "$GREEN" "🎉 chezmoi initialization and SSH switch complete!"

# Note: You do NOT need a configured SSH key when switching to SSH remote.
# However, to pull/push later via SSH, you WILL need a valid SSH key added to GitHub.

# Prompt user to restart
echo
read -rp "$(echo -e "${YELLOW}⚠️  Would you like to restart the machine now to ensure all changes are applied? (y/N): ${NC}")" restart_answer
case "$restart_answer" in
  [yY][eE][sS]|[yY])
    print_status "$BLUE" "🔁 Restarting the system..."
    sudo reboot
    ;;
  *)
    print_status "$YELLOW" "⏭️  Restart skipped. You may want to restart later to ensure all changes are applied."
    ;;
esac
