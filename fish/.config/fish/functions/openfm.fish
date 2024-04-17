# Opens the current directory in the default file manager.
# Usage: openfm
function openfm
	open .; or xdg-open .; or gnome-open .; or nautilus .; or dolphin .
end
