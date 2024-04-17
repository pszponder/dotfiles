# Changes to the root of the current Git repository.
# Usage: rootgit
function rootgit
	cd (git rev-parse --show-toplevel)
end