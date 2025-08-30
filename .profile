#!/bin/sh

# Main setup file executed for all kinds of shells


# Prevent loading ~/.profile twice in `bash`
export PROFILE_LOADED=1


# Basic utilities

_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

_in_bash() {
    [ -n "$BASH_VERSION" ]
}

_in_zsh() {
    [ -n "$ZSH_VERSION" ]
}

_prepend_to_path () {
    if [ -d "$1" ] ; then
        case :$PATH: in
            *:$1:*) ;;
            *) PATH=$1:$PATH ;;
        esac
    fi
}


# Load configuration files common to all kinds of shells
[ -f "$HOME/.config/shell/env" ] && . "$HOME/.config/shell/env"
[ -f "$HOME/.config/shell/aliases" ] && . "$HOME/.config/shell/aliases"


# Source ~/.profile_local, which holds machine-specific ENV variables
[ -f "$HOME/.profile_local" ] && . "$HOME/.profile_local"


# Load `bash`-specific configurations for non-login `bash` shells
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi


# Put local executables on the `$PATH`
_prepend_to_path "$HOME/.local/bin"


# Ensure ~/.profile is loaded each time `bash` starts
unset PROFILE_LOADED
