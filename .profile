# Executed by a login shell (e.g., bash or sh) during start


# Prepend a folder to $PATH if it is not already there
_prepend_to_path () {
    if [ -d "$1" ] ; then
        case :$PATH: in
            *:$1:*) ;;
            *) PATH=$1:$PATH ;;
        esac
    fi
}

# Put some private bin directories on the $PATH
_prepend_to_path "$HOME/bin"
_prepend_to_path "$HOME/.local/bin"


# Generic environment variables
export EDITOR=vim
export HISTFILESIZE=999999
export PAGER='less --chop-long-lines --ignore-case --LONG-PROMPT --no-init --status-column --quit-if-one-screen'
export TERM=xterm-256color
export TZ='Europe/Berlin'
export VISUAL=$EDITOR

# Machine-specific directories
export REPOS="$HOME/repos"


# Configurations for various utilities

export BAT_CONFIG_PATH="$HOME/.config/bat/config"

export LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/.lesshst"

export PYENV_ROOT="$HOME/.pyenv"
_prepend_to_path "$PYENV_ROOT/bin"
# No need for *.pyc files on a dev machine
export PYTHONDONTWRITEBYTECODE=1

export PSQLRC="$HOME/.psqlrc"


# Shell-specific stuff

# zsh-specific stuff is automatically sourced from `~/.zshenv`, `~/.zprofile`, `~/.zlogin`, and `~/.zshrc`

# Source `~/.bashrc` if we are running inside a BASH shell
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        # `~/.bashrc` is NOT automatically sourced by bash
        source "$HOME/.bashrc"
    fi
fi
