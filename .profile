# Executed by a login shell (e.g., bash, sh, or zsh) during start-up



# Shell-independent stuff


# Configure the standard XDG base directories
# Further Info: https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"  # also set temporarily in $XDG_DATA_HOME/dotfiles/setup.sh
export XDG_STATE_HOME="$HOME/.local/state"  # also set temporarily in $XDG_DATA_HOME/dotfiles/setup.sh
# Make up a XDG directory for binaries (that does not exist in the standard)
export XDG_BIN_HOME="$HOME/.local/bin"  # also set temporarily in $XDG_DATA_HOME/dotfiles/setup.sh


# Move common tools' config and cache files into XDG directories
export BAT_CONFIG_PATH="$XDG_CONFIG_PATH/bat/config"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"
export SSB_HOME="$XDG_DATA_HOME"/zoom
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"


# Generic shell configs
export EDITOR=vim
export PAGER='less --chop-long-lines --ignore-case --LONG-PROMPT --no-init --status-column --quit-if-one-screen'
export TERM=xterm-256color
export TZ='Europe/Berlin'
export VISUAL=$EDITOR


# Convenience variables for easier access of some locations
export REPOS="$HOME/repos"


# Python-specific configs
export PIPX_BIN_DIR=$XDG_BIN_HOME
export PYENV_ROOT="$HOME/.pyenv"
# No need for *.pyc files on a dev machine
export PYTHONDONTWRITEBYTECODE=1


# Put local binaries on the $PATH
prepend-to-path () {  # if not already there
    if [ -d "$1" ] ; then
        case :$PATH: in
            *:$1:*) ;;
            *) PATH=$1:$PATH ;;
        esac
    fi
}

prepend-to-path "$HOME/bin"
prepend-to-path "$HOME/.local/bin"
prepend-to-path "$PYENV_ROOT/bin"



# Shell-specific stuff


# zsh-specific stuff is automatically sourced from
# $XDG_CONFIG_HOME/zsh/.zshenv, $XDG_CONFIG_HOME/zsh/.zprofile,
# $XDG_CONFIG_HOME/zsh/.zlogin, and $XDG_CONFIG_HOME/.zshrc


# Source ~/.bashrc if we are running inside a bash shell
# because it is NOT automatically sourced by bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi


# Source ~/.profile_local, which holds machine-specific ENV variables
if [ -f "$HOME/.profile_local" ]; then
    source "$HOME/.profile_local"
fi
