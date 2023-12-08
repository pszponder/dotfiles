#!/usr/bin/env bash

# Install dependencies
sudo apt install fontforge -y
sudo apt-get install python3-fontforge

# Clone Repos
# Clone Font Patcher repo (https://github.com/ryanoasis/nerd-fonts)
git clone https://github.com/ryanoasis/nerd-fonts

# Clone Ligaturizer repo (https://github.com/ToxicFrog/Ligaturizer)
git clone git@github.com:ToxicFrog/Ligaturizer.git --recurse-submodules

# Create var to store the name of the font
font_name="ComicCode"

# Create a new directory to store the fonts
mkdir -p ./fonts-to-patch/$font_name/patchme
mkdir -p ./fonts-to-patch/$font_name/patced

# Copy fonts to patch into the new directory (./fonts-to-patch/patchme)
echo "TODO: Copy fonts to patch into the new directory (./fonts-to-patch/$font_name/patchme)"
exit 1

# Run Font Patcher
# https://hub.docker.com/r/nerdfonts/patcher
cd nerd-fonts
sudo docker run --rm \
	-v ./fonts-to-patch/$font_name/patchme:/in \
	-v ./fonts-to-patch/$font_name/patched:/out \
	nerdfonts/patcher \
	--progressbars \
	--adjust-line-height \
	--complete

# Copy patched fonts to Ligaturizer's fonts directory
mkdir -p ./Ligaturizer/fonts/$font_name
cp ./fonts-to-patch/$font_name/patched/* ./Ligaturizer/fonts/$font_name

# TODO: Add font to Ligaturizer's build.py file (in prefixed_fonts array)
echo "TODO: Add font to Ligaturizer's build.py file (in prefixed_fonts array)"
exit 1

# Run Ligaturizer
cd Ligaturizer
make

# Copy patched fonts to ~/.local/share/fonts and update the font cache
mkdir -p ~/.local/share/fonts/$font_name
cp ./fonts/$font_name/* ~/.local/share/fonts/$font_name
fc-cache -f -v