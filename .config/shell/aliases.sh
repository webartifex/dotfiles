# Shell aliases for bash


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}



# Re-run last command with sudo privileges
alias ,,='sudo $(history -p !!)'


# (Non-)obvious synonyms
alias cls='clear'
alias help='man'


# Avoid bad mistakes and show what happens
alias cp="cp --interactive --verbose"
alias ln='ln --interactive --verbose'
alias mv='mv --interactive --verbose'
alias rm='rm -I --preserve-root --verbose'


# Make working with files more convenient

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


# Various one-line utilities
alias datetime='date +"%Y-%m-%d %H:%M:%S %z (%Z)"'
alias datetime-iso='date --iso-8601=seconds'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias external-ip="curl https://icanhazip.com"
alias external-ip-alt="curl https://ipinfo.io/ip\?token=cfd78a97e15ebf && echo"
alias external-ip-extended-infos="curl https://ipinfo.io/json\?token=cfd78a97e15ebf && echo"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/22210ca35228f0bbcef75a7c14587c4ecb875ab4/speedtest.py | python -"


# Fix common typos
_command_exists ifconfig && alias ipconfig='ifconfig'
_command_exists R && alias r='R'


# Use sane defaults
_command_exists exa && alias exa='exa --group-directories-first --git --time-style=long-iso'
_command_exists netstat && alias ports='netstat -tulanp'
_command_exists screenfetch && alias screenfetch='screenfetch -n'
alias uptime='uptime --pretty'
alias wget='wget --continue'


# Create shorter aliases for various utilities
_command_exists batcat && alias bat='batcat'
_command_exists fdfind && alias fd='fdfind'
_command_exists neofetch && alias nf='neofetch'
_command_exists ranger && alias rn='ranger'
_command_exists screenfetch && alias sf='screenfetch'
