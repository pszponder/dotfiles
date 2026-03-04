#!/usr/bin/env bash
set -euo pipefail

# Define your list of paths here
PATHS=(
    "$HOME/repos/github/pszponder"
    "$HOME/sandbox"
    "$HOME/courses"
    "$HOME/resources"
)

echo "Starting directory creation..."

# Loop through the array
for dir in "${PATHS[@]}"; do
    mkdir -p "$dir"
    echo "Created directory at path: $dir"
done

echo "Structure complete!"