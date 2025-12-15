#!/usr/bin/env bash

set -euo pipefail

# Overwrite existing non-symlink files in target with repo-managed symlinks via GNU Stow.
# - Detects conflicts via `stow --simulate`
# - Backs up conflicting files to ~/.stow_backup/<timestamp>/ preserving paths
# - Removes originals, then runs `stow` to link
#
# Usage:
#   scripts/stow_overwrite.sh <package>
# Examples:
#   scripts/stow_overwrite.sh dots

pkg=${1:-}
if [[ -z "$pkg" ]]; then
  echo "Usage: $0 <package>" >&2
  exit 2
fi

# Ensure we run from repo root (where packages live)
script_dir=$(cd "$(dirname "$0")" && pwd)
repo_root=$(cd "$script_dir/.." && pwd)
cd "$repo_root"

# Read target from .stowrc if present; default to parent of repo_root
target_dir=${STOW_TARGET:-}
if [[ -f .stowrc ]]; then
  # naive parse of --target=VALUE (supports ~)
  tline=$(grep -E "^--target=" .stowrc || true)
  if [[ -n "$tline" ]]; then
    target_dir=${tline#--target=}
  fi
fi
target_dir=${target_dir:-$(dirname "$repo_root")}
# expand ~ if present
eval target_dir="$target_dir"

backup_root="$HOME/.stow_backup/$(date +%Y%m%d-%H%M%S)"

echo "Repo: $repo_root"
echo "Package: $pkg"
echo "Target: $target_dir"
echo "Backup: $backup_root"

# Simulate to detect conflicts
conflicts=$(stow -n -v "$pkg" 2>&1 | awk '/conflicts:/,0')

if [[ -z "$conflicts" ]]; then
  echo "No conflicts detected. Proceeding to stow..."
  stow -v "$pkg"
  exit 0
fi

echo "Conflicts found. Backing up and removing conflicting files..."
mkdir -p "$backup_root"

# Parse lines like:
#   * cannot stow <repo_path> over existing target <target_rel_path> since ...
echo "$conflicts" | grep -E "\* cannot stow" | while read -r line; do
  # extract target relative path after 'existing target '
  target_rel=$(echo "$line" | sed -E 's/.*existing target ([^ ]+) .*/\1/')
  src_path="$target_dir/$target_rel"

  if [[ -e "$src_path" && ! -L "$src_path" ]]; then
    backup_path="$backup_root/$target_rel"
    mkdir -p "$(dirname "$backup_path")"
    echo "Backing up: $src_path -> $backup_path"
    cp -a "$src_path" "$backup_path"
    echo "Removing original: $src_path"
    rm -rf "$src_path"
  else
    echo "Skipping $src_path (does not exist or already symlink)"
  fi
done

echo "Running stow to create symlinks..."
stow -v "$pkg"
echo "Done. Backups stored in: $backup_root"
