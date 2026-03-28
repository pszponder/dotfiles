#!/usr/bin/env bash
set -euo pipefail

KITTY_APP_DIR="$HOME/.local/kitty.app"
KITTY_BIN="$KITTY_APP_DIR/bin/kitty"
LOCAL_BIN="$HOME/.local/bin"
APPLICATIONS_DIR="$HOME/.local/share/applications"

# Install kitty via official binary installer (works on any Linux distro)
echo "📥 Installing kitty terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

# Create symlinks in ~/.local/bin (already on PATH)
echo "🔗 Creating symlinks in $LOCAL_BIN..."
mkdir -p "$LOCAL_BIN"
ln -sf "$KITTY_APP_DIR/bin/kitty" "$LOCAL_BIN/"
ln -sf "$KITTY_APP_DIR/bin/kitten" "$LOCAL_BIN/"

# Desktop integration
echo "🖥 Setting up desktop integration..."
mkdir -p "$APPLICATIONS_DIR"

cp "$KITTY_APP_DIR/share/applications/kitty.desktop" "$APPLICATIONS_DIR/"
cp "$KITTY_APP_DIR/share/applications/kitty-open.desktop" "$APPLICATIONS_DIR/"

# Update Icon and Exec paths in .desktop files
KITTY_ICON="$(readlink -f "$HOME")/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png"
KITTY_EXEC="$(readlink -f "$HOME")/.local/kitty.app/bin/kitty"

sed -i "s|Icon=kitty|Icon=${KITTY_ICON}|g" "$APPLICATIONS_DIR"/kitty*.desktop
sed -i "s|Exec=kitty|Exec=${KITTY_EXEC}|g" "$APPLICATIONS_DIR"/kitty*.desktop

echo "✅ kitty installation complete."
