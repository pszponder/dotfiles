# Creates a tarball of the specified directory.
# Usage: tart [directory]
# Example: tart project_folder
function tart
	tar -czvf "$argv.tar.gz" "$argv"
end