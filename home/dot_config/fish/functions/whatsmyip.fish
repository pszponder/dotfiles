# Show internal and external IP addresses
function whatsmyip
    echo -n "Internal IP: "
    if type -q ip
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else if type -q ifconfig
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    else
        echo "Unable to detect internal IP"
    end

    echo -n "External IP: "
    curl -4 ifconfig.me
end

alias whatismyip 'whatsmyip'