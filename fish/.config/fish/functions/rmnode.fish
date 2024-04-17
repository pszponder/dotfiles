# Searches for 'node_modules' directories from the current directory, lists them, and asks for confirmation before deletion.
# Usage: rmnode
function rmnode
	echo "Searching for 'node_modules' directories..."
	set dirs (find . -name "node_modules" -type d -prune)
	if test (count $dirs) -eq 0
		echo "No 'node_modules' directories found."
		return
	end
	echo "Found 'node_modules' directories in the following paths:"
	for dir in $dirs
		echo $dir
	end
	echo -n "Do you want to delete all these directories? (y/N) "
	read -l answer
	if test $answer = 'y' -o $answer = 'Y'
		for dir in $dirs
			echo "Removing $dir..."
			rm -rf $dir
		end
		echo "All 'node_modules' directories have been removed."
	else
		echo "Deletion cancelled."
	end
end