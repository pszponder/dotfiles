#!/usr/bin/env zsh

# =============
# ZSH FUNCTIONS
# =============

# Update Everything
# Updates System and Packages
update() {
	echo "\n==========================\nUPDATING SYSTEM...\n=========================="
	sudo apt update && sudo apt upgrade -y

	echo "\n==========================\nUPDATING BREW...\n=========================="
	brew update && brew upgrade

	echo "\n==========================\nUPDATING ZSH PLUGINS...\n=========================="
	zinit self-update
	zinit update --parallel

	echo "\n==========================\nUPDATING MISE LANGUAGES...\n=========================="
	mise upgrade
}

# Ripgrep + pretty print
# Usage: rg <search term>
function rg { command rg --json $@ | delta; }

# Creates a backup of a file with a .bak extension.
# Usage: backup [file]
# Example: backup important.txt
function backup() {
	cp $1{,.bak}
}

# Creates a tarball of the specified directory.
# Usage: tart [directory]
# Example: tart project_folder
function tart() {
	tar -czvf "$1.tar.gz" "$1"
}

# Extracts various compressed file formats. If no destination is specified, extracts to the current directory.
# Usage: extract [file] [destination]
# Example: extract archive.zip /path/to/destination
function extract() {
	if [ -f $1 ]; then
		local destination=${2:-$(pwd)}  # Use CWD if no destination is provided

		case $1 in
			*.tar.bz2) tar xjf $1 -C $destination ;;
			*.tar.gz)  tar xzf $1 -C $destination ;;
			*.bz2)     bunzip2 -k $1 && mv ${1%.bz2} $destination ;;
			*.rar)     unrar x $1 $destination ;;
			*.gz)      gunzip -k $1 && mv ${1%.gz} $destination ;;
			*.tar)     tar xf $1 -C $destination ;;
			*.tbz2)    tar xjf $1 -C $destination ;;
			*.tgz)     tar xzf $1 -C $destination ;;
			*.zip)     unzip $1 -d $destination ;;
			*.Z)       uncompress $1 && mv ${1%.Z} $destination ;;
			*.7z)      7z x $1 -o$destination ;;
			*)         echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Opens the current directory in the default file manager.
# Usage: openfm
function openfm() {
	open . || xdg-open . || gnome-open . || nautilus . || dolphin .
}

# Changes to a directory and then lists its contents.
# Usage: cdl [directory]
# Example: cdl /var/log
function cdl() {
	cd $1 && ls
}

# Creates a new directory and changes to it.
# Usage: mkcd [directory]
# Example: mkcd new_folder
function mkcd() {
	mkdir -p "$1" && cd "$1"
}

# Executes the last command with sudo.
# Usage: please
function please() {
	sudo $(fc -ln -1)
}

# Searches the command history for a specific pattern.
# Usage: hsearch [pattern]
# Example: hsearch git
function hsearch() {
	history | grep $1
}

# Starts a simple HTTP server in the current directory on port 8000.
# Usage: pyserve
function pyserve() {
	python -m SimpleHTTPServer
}

# Kills a process by its name.
# Usage: killproc [process_name]
# Example: killproc nginx
function killproc() {
	kill $(ps aux | grep $1 | grep -v grep | awk '{print $2}')
}

# Lists all open ports on your machine.
# Usage: lsoports
function lsoports() {
	sudo lsof -i -P -n | grep LISTEN
}

# Changes to the root of the current Git repository.
# Usage: rootgit
function rootgit() {
	cd $(git rev-parse --show-toplevel)
}

# Searches for 'node_modules' directories from the current directory, lists them, and asks for confirmation before deletion.
# Usage: rmnode
function rmnode() {
	echo "Searching for 'node_modules' directories..."
	local dirs=($(find . -name "node_modules" -type d -prune))

	if [ ${#dirs[@]} -eq 0 ]; then
		echo "No 'node_modules' directories found."
		return
	fi

	echo "Found 'node_modules' directories in the following paths:"
	for dir in "${dirs[@]}"; do
		echo $dir
	done

	echo -n "Do you want to delete all these directories? (y/N) "
	read answer
	if [[ $answer =~ ^[Yy]$ ]]; then
		for dir in "${dirs[@]}"; do
			echo "Removing $dir..."
			rm -rf $dir
		done
		echo "All 'node_modules' directories have been removed."
	else
		echo "Deletion cancelled."
	fi
}

# Create a new directory and navigate into it
function mkcd {
	if [ $# -eq 0 ]; then
		echo "Usage: mkcd <directory_name>"
	else
		mkdir -p "$1" && cd "$1"
	fi
}
