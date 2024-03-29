#!/usr/bin/env bash

# ================================================
# Install Brave Browser (https://brave.com/linux/)
# ================================================
echo "Installing Brave Browser..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# ================================================================
# Install VS Code (https://code.visualstudio.com/docs/setup/linux)
# ================================================================
echo "Installing VS Code..."
# Define the URL of the VSCode .deb package.
VS_CODE_URL="https://go.microsoft.com/fwlink/?LinkID=760868"
# Define the name of the downloaded file.
DEB_FILE="vscode.deb"
# Download the VSCode .deb package.
wget -O $DEB_FILE $VS_CODE_URL
# Add the downloaded .deb package to the APT repository and install.
sudo apt install ./$DEB_FILE
# Clean up the downloaded .deb file.
rm $DEB_FILE

# ================================================================
# Install Kitty Terminal (https://sw.kovidgoyal.net/kitty/binary/)
# ================================================================
echo "Installing Kitty Terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty.desktop file(s)
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# # ========================================================================
# # Install WezTerm (https://wezfurlong.org/wezterm/installation.html#linux)
# # ========================================================================
# echo "Installing WezTerm..."
# flatpak install flathub org.wezfurlong.wezterm

# ===============
# Install Discord
# ===============
echo "Installing Discord..."
flatpak install flathub com.discordapp.Discord

# ================
# Install Obsidian
# ================
echo "Installing Obsidian..."
flatpak install flathub md.obsidian.Obsidian

# # ===============
# # Install Postman
# # ===============
# echo "Installing Postman..."
# # flatpak install flathub com.getpostman.Postman
# snap install postman

# ===================================
# Install Bruno (Postman Alternative)
# https://www.usebruno.com/
# ===================================
# echo "Installing Bruno..."
# nix-env -iA nixpkgs.bruno
# snap install bruno

# =========================================================
# Install Docker Engine
# https://docs.docker.com/engine/
# https://docs.docker.com/engine/install/linux-postinstall/
# =========================================================

echo "Installing Docker Engine..."

# Uninstall old versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Engine
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create the docker group.
sudo groupadd docker

# Add your user to the docker group (log out and back in if necessary)
sudo usermod -aG docker $USER

# =======================================================
# Install Neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim
# =======================================================

# NOTE: Take a look at bob https://github.com/MordechaiHadad/bob as an alternative to the below

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
