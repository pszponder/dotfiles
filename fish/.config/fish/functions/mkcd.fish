# Create a new directory and navigate into it
function mkcd
	if test (count $argv) -eq 0
		echo "Usage: mkcd <directory_name>"
	else
		mkdir -p $argv; and cd $argv
	end
end