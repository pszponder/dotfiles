#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/logging.sh"

ssh_dir="$HOME/.ssh"
personal_dir="$ssh_dir/github/pszponder"

mkdir -p -- "$personal_dir"
chmod 700 -- "$ssh_dir" "$ssh_dir/github" "$personal_dir"

if [[ ! -e $ssh_dir/default && ! -e $ssh_dir/default.pub ]]; then
    ssh-keygen -t ed25519 -f "$ssh_dir/default" -C "default"
else
    log_info "Skipping $ssh_dir/default: a key file already exists"
fi

if [[ ! -e $personal_dir/personal && ! -e $personal_dir/personal.pub ]]; then
    ssh-keygen -t ed25519 -f "$personal_dir/personal" -C "personal-github"
else
    log_info "Skipping $personal_dir/personal: a key file already exists"
fi
