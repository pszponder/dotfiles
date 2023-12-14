#!/usr/bin/env bash

# Download the latest .deb package from the official Visual Studio Code repository
wget -O /tmp/code.deb https://go.microsoft.com/fwlink/?LinkID=760868

# Check if the download was successful
if [ $? -eq 0 ]; then
	echo "Download successful."

	# Install the downloaded package
	sudo dpkg -i /tmp/code.deb

	# Check if the installation was successful
	if [ $? -eq 0 ]; then
		echo "Installation successful."

		# Remove the downloaded .deb package
		rm /tmp/code.deb
	else
		echo "Installation failed."
	fi
else
	echo "Download failed."
fi
