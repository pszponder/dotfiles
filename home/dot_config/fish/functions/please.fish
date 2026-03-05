# Retry last command with sudo
function please
    # Only works interactively — grab last history line
    set -l last_cmd (history --max=1 | string trim | string split \n | head -n1)
    if test -n "$last_cmd"
        echo "Running with sudo: $last_cmd"
        eval sudo $last_cmd
    end
end