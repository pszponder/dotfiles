# Find all text log files under /var/log (ignores binary files and numbered rotated logs), and tail them all
function logs
    sudo find /var/log -type f -exec file {} \; |
        grep 'text' |
        cut -d' ' -f1 |
        sed -e 's/:$//g' |
        grep -v '[0-9]$' |
        xargs tail -f
end