# Make and enter a directory
function mkdircd
    if test (count $argv) -ne 1
        echo "Usage: mkdircd <directory>"
        return 1
    end

    mkdir -p "$argv[1]"
    cd "$argv[1]"
end