# Executed by a login shell (e.g., bash, sh, or zsh) during start-up


export PAGER='less --chop-long-lines --ignore-case --LONG-PROMPT --no-init --status-column --quit-if-one-screen'
export TERM=xterm-256color
export TZ='Europe/Berlin'

export REPOS="$HOME/repos"

export LESSHISTFILE="$HOME/.lesshst"



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



# Shell-specific stuff

# Source ~/.bashrc if we are running inside a bash shell
# because it is NOT automatically sourced by bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi
