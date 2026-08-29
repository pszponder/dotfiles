#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/../utils/utils_logging.sh"

# Omarchy is required for webapp installation.
if ! command -v omarchy >/dev/null 2>&1; then
  log_warn "Omarchy is not available. Skipping webapp installation."
  exit 0
fi

log_info "Installing web application(s) for Omarchy..."

install_webapps() {
  webapps="
Gemini|https://gemini.google.com/app
GitHub|https://github.com/pszponder
Gmail|https://mail.google.com
LinkedIn|https://linkedin.com
YouTube Music|https://music.youtube.com
"

  while IFS='|' read -r name url; do
    # Skip empty lines.
    [ -z "$name" ] && continue

    log_info "Installing web app: $name"

    if omarchy webapp install "$name" "$url" ""; then
      log_success "Installed $name"
    else
      log_warn "Failed to install $name"
    fi
  done <<EOF
$webapps
EOF
}

install_webapps

log_success "Webapp installation complete."