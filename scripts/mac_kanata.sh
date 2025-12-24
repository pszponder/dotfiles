#!/usr/bin/env bash
set -euo pipefail

### --- Resolve active user safely ---
CONSOLE_USER="$(stat -f '%Su' /dev/console)"

if [[ "$CONSOLE_USER" == "root" || -z "$CONSOLE_USER" ]]; then
  echo "❌ Could not determine active console user"
  exit 1
fi

USER_HOME="$(dscl . -read /Users/$CONSOLE_USER NFSHomeDirectory | awk '{print $2}')"

### --- Resolve kanata binary ---
KANATA_BIN="$(command -v kanata || true)"

if [[ -z "$KANATA_BIN" ]]; then
  echo "❌ kanata not found in PATH"
  echo "Install it first (e.g. brew install kanata)"
  exit 1
fi

### --- Resolve config path ---
KANATA_CONFIG="${KANATA_CONFIG:-$USER_HOME/.config/kanata/kanata.kbd}"

if [[ ! -f "$KANATA_CONFIG" ]]; then
  echo "❌ Kanata config not found: $KANATA_CONFIG"
  exit 1
fi

echo "Using kanata binary: $KANATA_BIN"
echo "Using config file:    $KANATA_CONFIG"
echo "Console user:         $CONSOLE_USER"

---

### --- Install Karabiner DriverKit ---
echo "Fetching latest Karabiner DriverKit pkg URL..."

DRIVERKIT_PKG_URL="$(
  curl -s https://api.github.com/repos/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/latest |
  jq -r '.assets[] | select(.name|endswith(".pkg")) | .browser_download_url'
)"

if [[ -z "$DRIVERKIT_PKG_URL" ]]; then
  echo "❌ Failed to locate DriverKit package"
  exit 1
fi

echo "Downloading DriverKit from: $DRIVERKIT_PKG_URL"
curl -L -o /tmp/karabiner-driverkit.pkg "$DRIVERKIT_PKG_URL"

echo "Installing DriverKit..."
sudo installer -pkg /tmp/karabiner-driverkit.pkg -target /
rm -f /tmp/karabiner-driverkit.pkg

---

### --- launchd services ---
service_name='com.jtroo.kanata'
driver_daemon='org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon'
driver_manager='org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Manager'

declare -A service_configs

service_configs["$driver_manager"]=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$driver_manager</string>
  <key>ProgramArguments</key>
  <array>
    <string>/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager</string>
    <string>activate</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
)

service_configs["$driver_daemon"]=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$driver_daemon</string>
  <key>ProgramArguments</key>
  <array>
    <string>/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
EOF
)

service_configs["$service_name"]=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$service_name</string>
  <key>ProgramArguments</key>
  <array>
    <string>$KANATA_BIN</string>
    <string>--cfg</string>
    <string>$KANATA_CONFIG</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/Library/Logs/Kanata/kanata.out.log</string>
  <key>StandardErrorPath</key>
  <string>/Library/Logs/Kanata/kanata.err.log</string>
</dict>
</plist>
EOF
)

---

### --- Install & enable services ---
for s in "${!service_configs[@]}"; do
  plist="/Library/LaunchDaemons/${s}.plist"

  if [[ ! -f "$plist" ]]; then
    echo "Installing $s"
    echo "${service_configs[$s]}" | sudo tee "$plist" >/dev/null
    sudo chown root:wheel "$plist"
    sudo chmod 644 "$plist"
  fi

  sudo launchctl print "system/$s" >/dev/null 2>&1 || {
    sudo launchctl bootstrap system "$plist"
    sudo launchctl enable "system/$s"
  }
done

---

### --- Permissions ---
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
read -rp "Add kanata to Accessibility, then press Enter to continue..."

open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
read -rp "Add kanata to Input Monitoring, then press Enter to continue..."

echo "✅ Kanata and Karabiner services are installed and enabled."
