# Move and go to directory
function mvg
    if test (count $argv) -ne 2
        echo "Usage: mvg <source_file> <target_dir_or_file>"
        return 1
    end

    mv "$argv[1]" "$argv[2]"
    if test -d "$argv[2]"
        cd "$argv[2]"
    end
end
