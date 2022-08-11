# This file defines various utilities regarding "the web"


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


# List all internal IPs
internal-ips() {
    if _command_exists ifconfig; then
        ifconfig | awk '/inet /{ gsub(/addr:/, ""); print $2 }'
    else
        echo 'ifconfig not installed'
    fi
}


# Obtain a weather report
weather() {
    if [ -n "$1" ]; then
        curl "v1.wttr.in/$1"
    else
        curl 'v1.wttr.in'
    fi
}
