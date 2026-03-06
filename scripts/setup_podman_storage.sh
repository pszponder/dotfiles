#!/usr/bin/env bash
set -euo pipefail

if ! command -v podman &>/dev/null; then
  echo "ℹ️ Podman not found, skipping storage driver setup."
  exit 0
fi

STORAGE_CONF="${HOME}/.config/containers/storage.conf"
STORAGE_DIR="${HOME}/.local/share/containers/storage"

# Detect the filesystem type backing the containers storage path.
# Walk up to the nearest existing ancestor so this works before the
# storage directory has been created.
detect_fs() {
  local dir="$STORAGE_DIR"
  while [[ ! -d "$dir" ]]; do
    dir="$(dirname "$dir")"
  done
  df --output=fstype "$dir" | tail -n1 | tr -d '[:space:]'
}

FS_TYPE="$(detect_fs)"

case "$FS_TYPE" in
  btrfs)  DRIVER="btrfs"   ;;
  zfs)    DRIVER="zfs"     ;;
  *)      DRIVER="overlay"  ;;
esac

echo "📦 Detected filesystem: ${FS_TYPE} → using Podman storage driver: ${DRIVER}"

# Only write the config if it needs changing
if [[ -f "$STORAGE_CONF" ]] && grep -q "^driver *= *\"${DRIVER}\"" "$STORAGE_CONF"; then
  echo "✅ ${STORAGE_CONF} already configured for ${DRIVER}, nothing to do."
  exit 0
fi

mkdir -p "$(dirname "$STORAGE_CONF")"
cat > "$STORAGE_CONF" <<EOF
[storage]
driver = "${DRIVER}"
EOF

# Remove stale storage that may reference a different driver, since even
# 'podman system reset' fails when the old driver is incompatible.
if [[ -d "$STORAGE_DIR" ]]; then
  echo "⚠️ Removing old storage directory to avoid driver mismatch..."
  rm -rf "$STORAGE_DIR"
fi

echo "✅ Wrote ${STORAGE_CONF} with driver = \"${DRIVER}\""
