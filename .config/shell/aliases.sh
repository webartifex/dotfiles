# Shell aliases used for both bash and zsh


# Check if a command can be found on the $PATH.
command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

# Check if we are running from within a zsh instance.
in_zsh() {
    [ -n "$ZSH_VERSION" ]
}


# Re-run last command with sudo privileges
if in_zsh; then
    alias ,,='sudo $(fc -ln -1)'
else
    alias ,,='sudo $(history -p !!)'
fi


# Global aliases
if in_zsh; then
    alias -g F='| fzf'
    alias -g G='| grep'
    alias -g H='| head'
    alias -g L='| less'
    alias -g T='| tail'
    alias -g NE='2 > /dev/null'
    alias -g NUL='> /dev/null 2>&1'
fi


alias cls='clear'
alias help='man'


# Avoid bad mistakes and show what happens
alias cp="cp --interactive --verbose"
alias ln='ln --interactive --verbose'
alias mv='mv --interactive --verbose'
alias rm='rm -I --preserve-root --verbose'


# Make working with files more convenient

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias mkdir='mkdir -p'
alias md='mkdir'
alias rmdir='rmdir --parents --verbose'
alias rd='rmdir'

alias grep='grep --color=auto --exclude-dir={.cache,\*.egg-info,.git,.nox,.tox,.venv}'
alias egrep='egrep --color=auto --exclude-dir={.cache,\*.egg-info,.git,.nox,.tox,.venv}'
alias fgrep='fgrep --color=auto --exclude-dir={.cache,*.egg-info,.git,.nox,.tox,.venv}'

alias fdir='find . -type d -name'
alias ffile='find . -type f -name'

alias ls='ls --classify --color=auto --group-directories-first --human-readable --no-group --time-style=long-iso'
alias la='ls --almost-all'
alias lal='la -l'
alias ll='ls -l'
alias l.='ls --directory .*'
alias ll.='l. -l'

alias df='df --human-readable'
alias du='du --human-readable'
alias diff='diff --color=auto --unified'
command_exists colordiff && alias diff='colordiff --unified'
alias free='free --human --total'
alias less='less --chop-long-lines --ignore-case --LONG-PROMPT --no-init --status-column --quit-if-one-screen'
alias more='less'
alias tree='tree -C --dirsfirst'


# Make working with Python more convenient

alias py='python'
alias ipy='ipython'

if command_exists poetry; then
    alias pr='poetry run'
fi

if command_exists pyenv; then
    alias pyvenvs='pyenv virtualenvs --bare --skip-aliases'
    alias pyver='pyenv version'
    alias pyvers='pyenv versions --skip-aliases'
    alias pywhich='pyenv which'
fi


# Aliases for various utilities
alias datetime='date +"%Y-%m-%d %H:%M:%S %z (%Z)"'
alias datetime-iso='date --iso-8601=seconds'
alias external-ip="curl https://icanhazip.com"
alias external-ip-alt="curl https://ipinfo.io/ip\?token=cfd78a97e15ebf && echo"
alias external-ip-extended-infos="curl https://ipinfo.io/json\?token=cfd78a97e15ebf && echo"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/22210ca35228f0bbcef75a7c14587c4ecb875ab4/speedtest.py | python -"


# Fix common typos
command_exists ifconfig && alias ipconfig='ifconfig'
command_exists R && alias r='R'


# Use sane defaults
command_exists exa && alias exa='exa --group-directories-first --git --time-style=long-iso'
command_exists netstat && alias ports='netstat -tulanp'
command_exists screenfetch && alias screenfetch='screenfetch -n'
alias uptime='uptime --pretty'
alias wget='wget --continue'


# Create short aliases
command_exists batcat && alias bat='batcat'
command_exists fdfind && alias fd='fdfind'
command_exists ranger && alias rn='ranger'
command_exists screenfetch && alias sf='screenfetch'


# Integrate git
if command_exists git; then
    alias g='git'

    # All git aliases are shell aliases with a 'g' prefix.
    for al in $(git internal-aliases); do
        # Only "real" (i.e., short) aliases are created.
        [ ${#al} -lt 7 ] && eval "alias g$al='git $al'"
    done

    # Check if a 'main' branch exists in place of a 'master' branch.
    git_main_branch() {
        if [[ -n "$(git branch --list main)" ]]; then
           echo 'main'
        else
           echo 'master'
        fi
    }
fi


# (Un-)Encrypt vaults
alias open-documents-vault='gocryptfs -q -extpass "pass getraenkemarkt/vaults/documents" $HOME/nextcloud/vault/ $HOME/.vault/documents'
alias close-documents-vault='fusermount -q -u $HOME/.vault/documents'
