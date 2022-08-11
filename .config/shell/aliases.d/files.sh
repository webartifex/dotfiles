# Make working with files more convenient


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


# Avoid bad mistakes and show what happens
alias cp="cp --interactive --verbose"
alias ln='ln --interactive --verbose'
alias mv='mv --interactive --verbose'
alias rm='rm -I --preserve-root --verbose'


# Faster directory switching
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


# Convenient defaults
alias mkdir='mkdir -p'
alias md='mkdir'
alias rmdir='rmdir --parents --verbose'
alias rd='rmdir'


# Convenient grepping
alias grep='grep --color=auto --exclude-dir={.cache,\*.egg-info,.git,.nox,.tox,.venv}'
alias egrep='egrep --color=auto --exclude-dir={.cache,\*.egg-info,.git,.nox,.tox,.venv}'
alias fgrep='fgrep --color=auto --exclude-dir={.cache,*.egg-info,.git,.nox,.tox,.venv}'


# Convenient searching
alias fdir='find . -type d -name'
alias ffile='find . -type f -name'


# Convenient listings
alias ls='ls --classify --color=auto --group-directories-first --human-readable --no-group --time-style=long-iso'
alias la='ls --almost-all'
alias lal='la -l'
alias ll='ls -l'
alias l.='ls --directory .*'
alias ll.='l. -l'


# More convenience with various other file-related utilities
alias df='df --human-readable'
alias du='du --human-readable'
alias diff='diff --color=auto --unified'
_command_exists colordiff && alias diff='colordiff --unified'
alias free='free --human --total'
alias less='less --chop-long-lines --ignore-case --LONG-PROMPT --no-init --status-column --quit-if-one-screen'
alias more='less'
alias tree='tree -C --dirsfirst'
