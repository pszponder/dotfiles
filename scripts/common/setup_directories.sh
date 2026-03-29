#!/usr/bin/env bash
set -euo pipefail

# Load logging utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils_logging.sh"

# Allow override via env var, fallback to default
ROOT_PATH="${ROOT_PATH:-$HOME}"

# Define paths relative to ROOT_PATH
PATHS=(
  "repos/github/pszponder"
  "sandbox"
  "courses"
  "resources"
)

log_info "Using root path: $ROOT_PATH"
log_info "Starting directory creation..."

for rel_path in "${PATHS[@]}"; do
  full_path="$ROOT_PATH/$rel_path"

  if mkdir -p "$full_path"; then
    log_success "Created directory: $full_path"
  else
    log_error "Failed to create directory: $full_path"
  fi
done

log_success "Directory creation complete!"