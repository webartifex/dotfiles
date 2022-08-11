# The utilities defined here make working with files and folders easier


# List the $PATH variable, one element per line
# (if an argument is passed, grep for it)
path() {
    if [ -n "$1" ]; then
        echo $PATH | perl -p -e 's/:/\n/g;' | grep -i "$1"
    else
        echo $PATH | perl -p -e 's/:/\n/g;'
    fi
}


# Show folders by size
disk-usage() {
    if [ -n "$1" ]; then
        _dest="$1"
    else
        _dest=.
    fi
    \du --human-readable --max-depth=1 $_dest 2>/dev/null | sort --human-numeric-sort --reverse
}


# Search all files in a directory and its children
lsgrep() {
    ls --almost-all --directory . ./**/* | uniq | grep --color=auto -i "$*"
}

# Make a directory and cd there
mcd() {
    test -n "$1" || return
    mkdir -p "$1" && cd "$1" || return
}


# Extract any compressed archive or file
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xjvf "$1" ;;
            *.tar.gz)  tar xzvf "$1" ;;
            *.tar.xz)  tar xvf "$1" ;;
            *.bz2)     bzip2 -d "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted automatically" ;;
        esac
    else
        echo "'$1' is not a file"
    fi
}

mktar() {  # out of a directory
    tar cvzf "${1%%/}.tar.gz" "${1%%/}/"
}

mkzip() {  # out of a file or directory
    zip -r "${1%%/}.zip" "$1"
}
