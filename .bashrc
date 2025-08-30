#!/bin/bash

# `bash`-specific configurations


# Load configuration files common to all kinds of shells,
# if not already done by a `bash` login shell
[ -z "$PROFILE_LOADED" ] && [ -f "$HOME/.profile" ] && . "$HOME/.profile"


# Ensure `bash` is running interactively
case $- in
    *i*) ;;
      *) return;;
esac


# Configure the `history`

# Set these environment variables here
# to avoid conflict/overlap with `zsh`

export HISTFILE="$XDG_STATE_HOME/bash/history"

export HISTSIZE=999999      # Number of lines kept in memory
export HISTFILESIZE=999999  # Number of lines kept in the `$HISTFILE`

# Ignore commands prefixed with a space
# and ones entered identically just before
export HISTCONTROL=ignoreboth

shopt -s cmdhist       # Remember multi-line commands as just one line
shopt -s histappend    # Do not overwrite the `$HISTFILE`
shopt -s histreedit    # Allow editing failed history substitutions
shopt -s lithist       # Store multi-line commands in history without `;`


# Make `bash` feel a bit more like `zsh`

shopt -s autocd        # Just type the directory to `cd` into it
shopt -s cdspell       # Correct minor spelling mistakes with `cd`
shopt -s checkjobs     # Show number of running jobs when exiting `bash`
shopt -s checkwinsize  # Update `$ROWS` and `$COLUMNS` after commands
shopt -s globstar      # Expand ** into recursive directories


stty -ixon             # Prevent Ctrl+S from freezing `bash`


# Make `bash` show `chroot`s
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# Make `bash` more colorful

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi


# Enable tab completion

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Add tab completion for all aliases to commands with completion functions
# (must come after bash completions have been set up)
# Source: https://superuser.com/a/437508
_alias_completion() {
    local namespace="alias_completion"
    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"
    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0
    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1
    local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"
    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"
        # skip aliases to pipes, boolean control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
        # avoid expanding wildcards
        read -a alias_arg_words <<< "$alias_args"
        # skip alias if there is no completion function triggered by the aliased command
        if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
            if [[ -n "$completion_loader" ]]; then
                # force loading of completions for the aliased command
                eval "$completion_loader $alias_cmd"
                # 124 means completion loader was successful
                [[ $? -eq 124 ]] || continue
                completions+=($alias_cmd)
            else
                continue
            fi
        fi
        local new_completion="$(complete -p "$alias_cmd")"
        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi
        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    . "$tmp_file" && \rm -f "$tmp_file"
}; _alias_completion
