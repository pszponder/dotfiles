# Kills a process by its name.
# Usage: killproc [process_name]
# Example: killproc nginx
function killproc
	kill (ps aux | grep $argv | grep -v grep | awk '{print $2}')
end