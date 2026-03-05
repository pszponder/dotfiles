# Search text in files (w/ color + pager)
function ftext
    if test (count $argv) -lt 1
        echo "Usage: ftext <search_term>"
        return 1
    end

    grep -iIHrn --color=always "$argv[1]" . | less -r
end