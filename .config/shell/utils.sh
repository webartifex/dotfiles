# This file initializes the shell and provides various utility functions


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}



# Configure the keyboard:
#  - make right alt and menu keys the compose key, e.g., for umlauts
#  - make caps lock a ctrl modifier and Esc key
setxkbmap us -option 'compose:menu,compose:ralt,caps:ctrl_modifier'
_command_exists xcape && xcape -e "Caps_Lock=Escape"



# ==============================
# Working with files and folders
# ==============================


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



# =================================
# Creating random login credentials
# =================================


genpw() {
    PARSED=$(getopt --quiet --options=acn: --longoptions=alphanum,clip,chars: -- "$@")
    eval set -- "$PARSED"
    SYMBOLS='--symbols'
    CHARS=30
    XCLIP=false
    while true; do
        case "$1" in
            -a|--alphanum)
                SYMBOLS=''
                shift
                ;;
            -c|--clip)
                XCLIP=true
                shift
                ;;
            -n|--chars)
                CHARS=$2
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                break
                ;;
        esac
    done
    PW=$(pwgen --ambiguous --capitalize --numerals --secure $SYMBOLS --remove-chars="|/\\\"\`\'()[]{}<>^~@§$\#" $CHARS 1)
    if [[ $XCLIP == true ]]; then
        echo $PW | xclip -selection c
    else
        echo $PW
    fi
}

alias genpw-alphanum='pwgen --ambiguous --capitalize --numerals --secure 30 1'


# Random email addresses that look like "normal" ones
genemail() {
    PARSED=$(getopt --quiet --options=c --longoptions=clip -- "$@")
    eval set -- "$PARSED"
    XCLIP=false
    while true; do
        case "$1" in
            -c|--clip)
                XCLIP=true
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                break
                ;;
        esac
    done
    FIRST=$(shuf -i 4-5 -n 1)
    LAST=$(shuf -i 8-10 -n 1)

    if _command_exists gpw; then
        USER="$(gpw 1 $FIRST).$(gpw 1 $LAST)@webartifex.biz"
    else
        # Fallback that looks a bit less "normal"
        USER="$(pwgen --no-capitalize --no-numerals --secure $FIRST 1).$(pwgen --no-capitalize --no-numerals --secure $LAST 1)@webartifex.biz"
    fi

    if [[ $XCLIP == true ]]; then
        echo $USER | xclip -selection c
    else
        echo $USER
    fi
}



# =============================
# Automate the update machinery
# =============================


_update_apt() {
    _command_exists apt || return

    echo 'Updating apt packages'
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
    sudo apt autoclean
}

_update_dnf() {
    _command_exists dnf || return

    echo 'Updating dnf packages'
    sudo dnf upgrade --refresh
    sudo dnf autoremove
    sudo dnf clean all
}

_remove_old_snaps() {
    sudo snap list --all | awk "/disabled/{print $1, $3}" |
        while read snapname revision; do
            sudo snap remove "$snapname" --revision="$revision"
        done
}


# Update local git repositories (mostly ~/repos)
_update_repositories() {
    echo 'Updating repositories'

    cwd=$(pwd)
    cd $REPOS

    for dir in */; do
        cd "$REPOS/$dir" && echo "Fetching $REPOS/$dir"
        git fetch --all --prune
    done

    _command_exists pass && echo "Fetching $HOME/.password-store" && pass git pull
    _update_dotfiles

    cd $cwd
}

# Update the ~/.dotfiles repository
_update_dotfiles() {
    echo "Fetching $HOME/.dotfiles"
    # The `dotfiles` alias is defined in ~/.bashrc at the end of the
    # "Shell Utilities & Aliases" section and can NOT be used here
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME stash --quiet 
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch --all --prune
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull --rebase --quiet
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME stash pop  # --quiet is ignored
}


update-machine() {
    sudo --validate || return

    _update_apt
    _update_dnf
    _command_exists flatpak && sudo flatpak update -y
    _command_exists snap && sudo snap refresh && _remove_old_snaps
    _update_repositories

    sudo --reset-timestamp
}



# =======================
# Various other Utilities
# =======================


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
