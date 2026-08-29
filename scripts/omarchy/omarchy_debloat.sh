#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

# Omarchy is required for this script.
if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy executable not found. Skipping debloat..."
  exit 0
fi

remove_webapps() {
  log_info "Removing unwanted web apps..."

  webapps="
Basecamp
Hey
WhatsApp
"

  for webapp in $webapps; do
    log_info "Removing web app: $webapp"

    if omarchy webapp remove "$webapp"; then
      log_success "Removed $webapp"
    else
      log_warn "Could not remove $webapp (it may not be installed)"
    fi
  done
}

debloat_omarchy() {
  log_info "Debloating Omarchy installation..."

  remove_webapps

  # Add additional debloating operations here.
  # remove_packages
  # disable_services
}

debloat_omarchy

log_success "Omarchy debloat complete."