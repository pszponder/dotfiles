#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/logging.sh"

directories=(
    "$HOME/repos/github"
    "$HOME/resources"
    "$HOME/scratch"
)

for directory in "${directories[@]}"; do
    if [[ -d $directory ]]; then
        log_info "Already exists: $directory"
    else
        mkdir -p -- "$directory"
        log_success "Created: $directory"
    fi
done
