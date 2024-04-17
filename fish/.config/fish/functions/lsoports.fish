# Lists all open ports on your machine.
# Usage: lsoports
function lsoports
	sudo lsof -i -P -n | grep LISTEN
end