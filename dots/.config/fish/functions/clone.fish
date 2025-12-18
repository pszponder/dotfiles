function clone
    if test (count $argv) -lt 1
        echo "Usage: clone <git-url> [directory]"
        return 1
    end

    set url $argv[1]
    set dir ''
    if test (count $argv) -ge 2
        set dir $argv[2]
    end

    if test -n "$dir"
        git clone "$url" "$dir"; or return $status
        cd "$dir"; or return $status
    else
        # Derive repo name from URL (strip trailing .git)
        set name (basename (string replace -r '\.git$' '' "$url"))
        git clone "$url"; or return $status
        cd "$name"; or begin
            echo "Could not cd into '$name' (clone may have used a different folder name)."
            return 1
        end
    end
end
