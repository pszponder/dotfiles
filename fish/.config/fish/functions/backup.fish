# Creates a backup of a file with a .bak extension.
# Usage: backup [file]
# Example: backup important.txt
function backup
	cp $argv{,.bak}
end