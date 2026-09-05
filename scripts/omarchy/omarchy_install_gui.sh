#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping GUI installation."
  exit 0
fi

log_info "Installing GUI application(s) for Omarchy..."

log_info "Installing Ghostty..."
omarchy install terminal ghostty

install_aur_packages() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi

  if ! omarchy pkg aur accessible; then
    log_warn "The AUR is not accessible. Skipping AUR package installation."
    return 0
  fi

  for package in "$@"; do
    if omarchy pkg present "$package"; then
      log_info "$package is already installed."
      continue
    fi

    log_info "Installing $package from the AUR..."
    if omarchy pkg aur add "$package"; then
      log_success "Installed $package."
    else
      log_warn "Could not install $package from the AUR."
    fi
  done
}

# install_aur_packages \
#   helium-browser-bin
