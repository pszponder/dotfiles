# Make and enter a directory
function mkdirg
    if test (count $argv) -ne 1
        echo "Usage: mkdirg <directory>"
        return 1
    end

    mkdir -p "$argv[1]"
    cd "$argv[1]"
end
