#!/bin/zsh

# `zsh`-specific configurations


# Remove built-in aliases because we use our own, sourced via ~/.profile
unalias -a


# Load configuration files common to all kinds of shells
[ -f "$HOME/.profile" ] && . "$HOME/.profile"


# Ensure `zsh` is running interactively
[[ -o interactive ]] || return


# Make `zsh` behave like `bash` for prompts
PS1='%n@%m:%~%(!.#.$) '


# Configure the `history`

# Set these environment variables here
# to avoid conflict/overlap with `bash`

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=999999  # Number of lines kept in memory
export SAVEHIST=999999  # Number of lines kept in the `$HISTFILE`

setopt APPEND_HISTORY      # Do not overwrite the `$HISTFILE`
setopt INC_APPEND_HISTORY  # Write to the `$HISTFILE` immediately
setopt HIST_REDUCE_BLANKS  # Remove superfluous blanks from the `history`
setopt HIST_VERIFY         # Show expanded `history` before executing


# Make `zsh` feel even nicer

setopt AUTO_CD         # Just type the directory to `cd` into it
setopt EXTENDED_GLOB   # Advanced globbing patterns
setopt NULL_GLOB       # Remove patterns with no matches
setopt CORRECT         # Correct spelling of commands
setopt CHECK_JOBS      # Show number of running jobs when exiting `zsh`
setopt NO_BEEP         # Silence `zsh`


stty -ixon             # Prevent Ctrl+S from freezing `zsh`


# Enable (tab) completions

autoload -Uz compinit && compinit

# Enable match highlighting and scrolling through long lists,
# and provide a different style of menu completion
zmodload zsh/complist

# Include hidden files in tab completion
_comp_options+=(GLOB_DOTS)

# Make selecting completions nicer with a visual menu
zstyle ':completion:*' menu select

# Make new executables completable right away
zstyle ':completion:*' rehash true


# Configure key bindings

# VI mode
bindkey -v

# Use VI keys to navigate the completions in the menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Enable Ctrl-R for reverse history search
bindkey "^R" history-incremental-search-backward
