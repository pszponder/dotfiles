# Executes the last command with sudo.
# Usage: please
function please
	sudo (history | tail -n 1)
end