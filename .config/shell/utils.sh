# This file is executed either by bash or zsh and holds all
# initializations and utility definitions used in both shells.


# Check if a command can be found on the $PATH.
command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

# Check if we are running from within a zsh instance.
in_zsh() {
    [ -n "$ZSH_VERSION" ]
}



# =========================
# Initialize some CLI tools
# =========================


# Load custom $LS_COLORS if available
if command_exists dircolors; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi


# Make less understand some binary types (e.g., PDFs)
# Source: https://github.com/wofr06/lesspipe
command_exists lesspipe && eval "$(SHELL=/bin/sh lesspipe)"


# Configure the keyboard:
#  - make right alt and menu keys the compose key, e.g., for umlauts
#  - make caps lock a ctrl modifier and Esc key
setxkbmap us -option 'compose:menu,compose:ralt,caps:ctrl_modifier'
command_exists xcape && xcape -e "Caps_Lock=Escape"



# ==============================
# Working with files and folders
# ==============================


# List the $PATH variable, one element per line
# If an argument is passed, grep for it
path() {
    if [ -n "$1" ]; then
        echo "$PATH" | perl -p -e 's/:/\n/g;' | grep -i "$1"
    else
        echo "$PATH" | perl -p -e 's/:/\n/g;'
    fi
}


# Show folders by size.
disk_usage() {
    local dest
    if [ -n "$1" ]; then
        dest="$1"
    else
        dest=.
    fi
    \du --human-readable --max-depth=1 $dest 2>/dev/null | sort --human-numeric-sort --reverse
}


# Search all files in a directory and its children.
lsgrep() {
    ls --almost-all --directory . ./**/* | uniq | grep --color=auto -i "$*"
}

# Make a directory and cd there.
mcd() {
    test -n "$1" || return
    mkdir -p "$1" && cd "$1" || return
}


# Extract a compressed archive or file.
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xjvf "$1" ;;
            *.tar.gz)  tar xzvf "$1" ;;
            *.tar.xz)  tar xvf "$1" ;;
            *.bz2)     bzip2 -d "$1" ;;
            *.rar)     unrar2dir "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip2dir "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *.ace)     unace x "$1" ;;
            *)         echo "'$1' cannot be extracted automatically" ;;
        esac
    else
        echo "'$1' is not a file"
    fi
}

# Create a tar.gz archive from a given directory.
mktar() {
    tar cvzf "${1%%/}.tar.gz" "${1%%/}/"
}

# Create a zip archive from a given file or directory.
mkzip() {
    zip -r "${1%%/}.zip" "$1"
}



# =================================
# Creating random login credentials
# =================================


# Create random passwords for logins
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
                echo 'Programming error'
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

# Short password that is accepted by most services
alias genpw-alphanum='pwgen --ambiguous --capitalize --numerals --secure 30 1'

# Email addresses created with this utility look kind of "normal" but are totally random
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
                echo 'Programming error'
                break
                ;;
        esac
    done
    FIRST=$(shuf -i 4-5 -n 1)
    LAST=$(shuf -i 8-10 -n 1)
    USER="$(gpw 1 $FIRST).$(gpw 1 $LAST)@webartifex.biz"
    if [[ $XCLIP == true ]]; then
        echo $USER | xclip -selection c
    else
        echo $USER
    fi
}



# =============================
# Automate the update machinery
# =============================


# Pull down latest version of dot files
update-dotfiles() {
    echo -e '\nUpdating dotfiles\n'

    # The `dotfiles` alias is defined in ~/.bashrc at the end of the "Shell Utilities & Aliases" section
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME stash 
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch --all --prune
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull --rebase
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME stash pop
}


# Run entire aptitude upgrade cycle (incl. removal of old packages).
update-apt() {
    echo -e '\nUpdating apt packages\n'

    sudo apt update
    echo
    sudo apt upgrade
    echo
    sudo apt autoremove
    echo
    sudo apt autoclean
}

remove-old-snaps() {
    sudo snap list --all | awk "/disabled/{print $1, $3}" |
        while read snapname revision; do
            sudo snap remove "$snapname" --revision="$revision"
        done
}


# Update all repositories in ~/repos without the ones related to zsh/zplug
update-repositories() {
    echo -e '\nUpdating repositories unrelated to zsh/zplug\n'

    local cwd
    cwd=$(pwd)
    cd "$REPOS"
    for dir in */; do
        [ "$dir" = "zsh/" ] && continue
        echo "$REPOS/$dir"
        cd "$REPOS/$dir"
        git stash
        git fetch --all --prune
        git pull --rebase
        git stash pop
        echo
    done
    cd "$cwd"
}

# Update everything related to zsh
update-zsh() {
    echo -e '\nUpdating zsh/zplug related repositories\n'

    if in_zsh; then
        omz update
        zplug update
        zplug install
        zplug load
    else
        local cwd
        cwd=$(pwd)
        # Pull down latest versions manually.
        for dir in $HOME/.zplug/repos/*/*/; do
            echo "$dir" && cd "$dir"
            git fetch --all --prune
            git pull --rebase
        done
        echo "$HOME/.oh-my-zsh" && cd "$HOME/.oh-my-zsh"
        git fetch --all --prune
        git pull --rebase
        cd "$cwd"
    fi
}


# Wrapper to run several update functions at once
update-machine() {
    sudo --validate || return

    update-apt

    if command_exists flatpak; then
        echo -e '\nUpdating flatpaks\n'
        sudo flatpak update -y
    fi

    if command_exists snap; then
        echo -e '\nUpdating snaps\n'
        sudo snap refresh
        remove-old-snaps
    fi

    update-dotfiles
    update-zsh

    echo -e '\nUpdating password store\n'
    pass git pull
    echo

    sudo updatedb -U /
    echo

    sudo --reset-timestamp
}



# =======================
# Various other Utilities
# =======================


# List all internal IPs.
internal-ips() {
    if command_exists ifconfig; then
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
