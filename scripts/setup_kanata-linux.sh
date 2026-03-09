#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ℹ️ Kanata Linux setup is only supported on Linux, skipping."
  exit 0
fi

echo "⌨️ Setting up Kanata keyboard remapper..."

# ---------------------------------------------------------------------------
# 1. Ensure the uinput group exists
# ---------------------------------------------------------------------------
if getent group uinput &>/dev/null; then
  echo "ℹ️ Group 'uinput' already exists."
else
  echo "==> Creating 'uinput' group..."
  sudo groupadd uinput
fi

# ---------------------------------------------------------------------------
# 2. Add user to input and uinput groups
# ---------------------------------------------------------------------------
add_user_to_group() {
  local group="$1"
  if id -nG "$USER" | grep -qw "$group"; then
    echo "ℹ️ User '$USER' is already in group '$group'."
  else
    echo "==> Adding '$USER' to group '$group'..."
    sudo usermod -aG "$group" "$USER"
  fi
}

add_user_to_group input
add_user_to_group uinput

# ---------------------------------------------------------------------------
# 3. Create udev rule for /dev/uinput permissions
# ---------------------------------------------------------------------------
UDEV_RULE='KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'
UDEV_FILE="/etc/udev/rules.d/99-input.rules"

if [[ -f "$UDEV_FILE" ]] && grep -qF "$UDEV_RULE" "$UDEV_FILE"; then
  echo "ℹ️ udev rule already present in $UDEV_FILE."
else
  echo "==> Writing udev rule to $UDEV_FILE..."
  echo "$UDEV_RULE" | sudo tee "$UDEV_FILE" > /dev/null
fi

# ---------------------------------------------------------------------------
# 4. Reload udev rules
# ---------------------------------------------------------------------------
echo "==> Reloading udev rules..."
sudo udevadm control --reload-rules && sudo udevadm trigger

# ---------------------------------------------------------------------------
# 5. Load the uinput kernel module
# ---------------------------------------------------------------------------
if lsmod | grep -qw uinput; then
  echo "ℹ️ Kernel module 'uinput' is already loaded."
else
  echo "==> Loading kernel module 'uinput'..."
  sudo modprobe uinput
fi

# Ensure the module loads at boot
MODULES_FILE="/etc/modules-load.d/uinput.conf"
if [[ -f "$MODULES_FILE" ]] && grep -qw "uinput" "$MODULES_FILE"; then
  echo "ℹ️ Module auto-load already configured in $MODULES_FILE."
else
  echo "==> Configuring 'uinput' to load at boot via $MODULES_FILE..."
  echo "uinput" | sudo tee "$MODULES_FILE" > /dev/null
fi

# ---------------------------------------------------------------------------
# 6. Install kanata binary via cargo
# ---------------------------------------------------------------------------
if command -v kanata &>/dev/null || [[ -x "$HOME/.cargo/bin/kanata" ]]; then
  echo "ℹ️ kanata binary already installed, skipping."
else
  if command -v cargo &>/dev/null; then
    echo "==> Installing kanata via cargo..."
    cargo install kanata
  else
    echo "⚠️ cargo not found, cannot install kanata. Ensure rust is installed via mise."
    exit 1
  fi
fi

# ---------------------------------------------------------------------------
# 7. Enable and start the systemd user service
# ---------------------------------------------------------------------------
if systemctl --user is-enabled kanata.service &>/dev/null; then
  echo "ℹ️ kanata.service is already enabled."
else
  echo "==> Enabling kanata.service..."
  systemctl --user daemon-reload
  systemctl --user enable kanata.service
fi

echo ""
echo "✅ Kanata setup complete."
echo "⚠️ You may need to log out and back in for group changes to take effect."
echo "   After re-login, start the service with: systemctl --user start kanata.service"
