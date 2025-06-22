#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define an array of flatpak apps to install
FLATPAK_APPS=(
  app.devsuite.Ptyxis               # Ptyxis – Terminal emulator with advanced features
  com.brave.Browser                 # Brave Browser – Privacy-focused web browser
  com.discordapp.Discord            # Discord – Voice, video, and text chat for communities
  com.github.PintaProject.Pinta     # Pinta – Simple image editor (like Paint.NET)
  com.github.tchx84.Flatseal        # Flatseal – Permissions manager for Flatpak apps
  com.jeffser.Alpaca                # Alpaca – ollama client for Linux
  com.jeffser.Pigment               # Pigment – Color picker and palette manager
  com.mattjakeman.ExtensionManager  # Extension Manager – Manage GNOME Shell extensions
  dev.zed.Zed                       # Zed – High-performance code editor
  io.github.flattool.Ignition       # Ignition – Manage startup apps and scripts
  io.github.flattool.Warehouse      # Warehouse – Flatpak app manager
  io.github.getnf.embellish         # Embellish – Font management tool
  io.gitlab.adhami3310.Impression   # Impression – Create bootable drives from iso files
  io.missioncenter.MissionCenter    # Mission Center – System monitor (like macOS Activity Monitor)
  io.podman_desktop.PodmanDesktop   # Podman Desktop
  it.mijorus.collector              # Collector – Drag and drop file organizer
  it.mijorus.gearlever              # Gear Lever – Appimage manager
  md.obsidian.Obsidian              # Obsidian – Markdown knowledge base and note-taking app
  me.iepure.devtoolbox              # Dev Toolbox – Developer tools and utilities
  org.gimp.GIMP                     # GIMP – GNU Image Manipulation Program
  org.gnome.Extensions              # GNOME Extensions – Manage installed GNOME Shell extensions
  org.gnome.World.PikaBackup        # Pika Backup – Backup tool for GNOME using Borg
  org.inkscape.Inkscape             # Inkscape – Vector graphics editor
  page.tesk.Refine                  # Refine – Metadata editor for media files
)

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to check if a flatpak app is already installed
flatpak_app_installed() {
  flatpak list --app | grep -q "$1"
}

# Check if Flatpak is installed
if ! command_exists flatpak; then
  echo "❌ Flatpak is not installed. Please run the install_flatpak.sh script first."
  exit 1
fi

# Make sure Flathub remote is added
if ! flatpak remotes | grep -q "flathub"; then
  echo "📥 Adding Flathub repository..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  echo "✅ Flathub repository added successfully."
fi

# Install flatpak applications
echo "📦 Installing Flatpak applications..."
for app in "${FLATPAK_APPS[@]}"; do
  # Skip comments (lines starting with #)
  if [[ "$app" == \#* ]] || [[ -z "$app" ]]; then
    continue
  fi

  # Check if app is already installed
  if flatpak_app_installed "$app"; then
    echo "✅ $app is already installed, skipping..."
  else
    echo "📥 Installing $app..."
    flatpak install -y flathub "$app"
  fi
done

echo "🎉 Flatpak applications installation completed!"

# Reminder about customizing apps
echo ""
echo "📝 Note: You can customize the list of applications by editing the FLATPAK_APPS array in this script."
echo "   Current location: $(readlink -f "$0")"
