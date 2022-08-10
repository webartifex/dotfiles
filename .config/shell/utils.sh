# This file initializes the shell and provides various utility functions


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

_in_zsh() {
    [ -n "$ZSH_VERSION" ]
}

prepend-to-path () {  # if not already there
    if [ -d "$1" ] ; then
        case :$PATH: in
            *:$1:*) ;;
            *) PATH=$1:$PATH ;;
        esac
    fi
}



# Configure the keyboard:
#  - make right alt and menu keys the compose key, e.g., for umlauts
#  - make caps lock a ctrl modifier and Esc key
setxkbmap us -option 'compose:menu,compose:ralt,caps:ctrl_modifier'
_command_exists xcape && xcape -e "Caps_Lock=Escape"



_init_pyenv () {  # used further below as well
    _command_exists pyenv || return

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}
_init_pyenv



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



# ===================================================
# Set up & maintain the Python (develop) environments
# ===================================================


# TODO: This needs to be updated regularly (or find an automated solution)
# The Python versions pyenv creates (in descending order
# Important: The first version also holds the "interactive" and "utils" environments)
_py3_versions=('3.10.6' '3.9.13' '3.8.13' '3.7.13')
_py2_version='2.7.18'

# Each Python version receives its own copy of black, pipenv, and poetry
# (e.g., to avoid possible integration problems between pyenv and poetry
#  Source: https://github.com/python-poetry/poetry/issues/5252#issuecomment-1055697424)
_py3_site_packages=('black' 'pipenv' 'poetry')

# The pyenv virtualenv "utils" contains some globally available tools (e.g., mackup)
_py3_utils=('leglight' 'mackup' 'youtube-dl')

# Important: this REMOVES the old ~/.pyenv installation
_install_pyenv() {
    echo "(Re-)Installing pyenv"

    # Ensure that pyenv is on the $PATH
    # (otherwise, the pyenv installer emits warnings)
    mkdir -p "$PYENV_ROOT/bin"
    prepend-to-path "$PYENV_ROOT/bin"

    # Remove old pyenv for clean install
    rm -rf "$PYENV_ROOT" >/dev/null

    # Run the official pyenv installer
    curl https://pyenv.run | bash

    # Make pyenv usable after this installation in the same shell session
    _init_pyenv
}

create-or-update-python-envs() {
    _command_exists pyenv || _install_pyenv

    eval "$(pyenv init --path)"

    # Keep a legacy Python 2.7, just in case
    echo "Installing/updating Python $_py2_version"
    pyenv install --skip-existing $_py2_version
    pyenv rehash  # needed on a first install
    PYENV_VERSION=$_py2_version pip install --upgrade pip setuptools
    PYENV_VERSION=$_py2_version python -c "import sys; print sys.version"

    for version in ${_py3_versions[@]}; do
        echo "Installing/updating Python $version"
        pyenv install --skip-existing $version
        pyenv rehash  # needed on a first install

        # Start the new environment with the latest pip and setuptools versions
        PYENV_VERSION=$version pip install --upgrade pip setuptools
        PYENV_VERSION=$version python -c "import sys; print(sys.version)"

        # Put the specified utilities in the fresh environments or update them
        for lib in ${_py3_site_packages[@]}; do
            PYENV_VERSION=$version pip install --upgrade $lib
        done
    done

    # Create a virtualenv based off the latest Python version to host global utilities
    echo "Installing/updating the global Python utilities"
    pyenv virtualenv $_py3_versions[1] 'utils'
    pyenv rehash  # needed on a first install
    PYENV_VERSION='utils' pip install --upgrade pip setuptools
    for util in ${_py3_utils[@]}; do
        PYENV_VERSION='utils' pip install --upgrade $util
    done

    # Create a virtualenv based off the latest Python version for interactive usage
    echo "Installing/updating the default/interactive Python environment"
    pyenv virtualenv $_py3_versions[1] 'interactive'
    pyenv rehash  # needed on a first install
    PYENV_VERSION='interactive' pip install --upgrade pip setuptools
    # Install some tools to make interactive usage nicer
    PYENV_VERSION='interactive' pip install --upgrade black bpython ipython

    # Put all Python binaries/virtualenvs and the utilities on the $PATH
    pyenv global 'interactive' $_py3_versions 'utils' $_py2_version
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

    # Otherwise the for-loop waites for manual input
    # if it cd's into a folder with a ".env" file
    ZSH_DOTENV_FILE='.do_not_run_dotenv'

    for dir in */; do
        cd "$REPOS/$dir" && echo "Fetching $REPOS/$dir"
        git fetch --all --prune
    done

    ZSH_DOTENV_FILE='.env'

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


_update_zsh() {
    _in_zsh || return

    echo 'Updating zsh'
    _update_omz_fork
    _update_zplug
}

_update_omz_fork() {
    _command_exists omz || return

    # In a nutshell, `omz update` pulls the latest origin/master
    # from the original "oh-my-zsh" repo
    omz update

    cwd=$(pwd)
    cd $ZSH

    git checkout --quiet forked  # most likely already the case

    # Keep our personal "oh-my-zsh" fork up-to-date
    # See: https://gitlab.webartifex.biz/alexander/oh-my-zsh
    git rebase --quiet master
    git push --quiet fork forked
    git push --quiet fork master

    cd $cwd
}

_update_zplug() {
    _command_exists zplug || return

    zplug update
    zplug install  # ensure newly added plugins in ~/.zshrc are never forgotten
    zplug load
}


_update_python() {
    echo 'Updating the Python tool chain'

    if _command_exists pyenv; then
        pyenv update
        create-or-update-python-envs
    fi

    if _command_exists zsh-pip-cache-packages; then
        zsh-pip-clear-cache
        zsh-pip-cache-packages
    fi
}


_restore_gnome() {
    for file in $HOME/.config/gnome-settings/*.ini; do
        dconf load / < $file
    done
}


run-private-scripts() {  # in the Nextcloud
    if [ -d "$HOME/data/getraenkemarkt/shell" ]; then
        for file in $HOME/data/getraenkemarkt/shell/*.sh; do
            source $file
        done
    fi
}


update-machine() {
    sudo --validate || return

    _update_apt
    _update_dnf
    _command_exists flatpak && sudo flatpak update -y
    _command_exists snap && sudo snap refresh && _remove_old_snaps
    _update_repositories
    _update_zsh
    _update_python
    _restore_gnome

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
