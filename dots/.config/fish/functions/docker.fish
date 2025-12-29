# Start Colima if available before invoking docker
function docker --wraps docker --description "Ensure Colima is running then call docker"
    if type -q colima
        set -l status_output (colima status 2>/dev/null)
        if not string match -qr 'Running' -- $status_output
            echo "Starting Colima..."
            colima start
        end
    else
        echo "Colima not found. Using Docker directly."
    end

    command docker $argv
end
