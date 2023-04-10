# Generic shell aliases for bash and zsh


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

_in_zsh() {
    [ -n "$ZSH_VERSION" ]
}


# Re-run last command with sudo privileges
if _in_zsh; then
    alias ,,='sudo $(fc -ln -1)'
else
    alias ,,='sudo $(history -p !!)'
fi


# Convenient piping with zsh
if _in_zsh; then
    alias -g B='| bat'
    alias -g F='| fzf'
    alias -g G='| grep'
    alias -g H='| head'
    alias -g L='| less'
    alias -g T='| tail'
    alias -g NE='2 > /dev/null'
    alias -g NUL='> /dev/null 2>&1'
fi


# (Non-)obvious synonyms
alias cls='clear'
alias help='man'


# Various one-line utilities
alias datetime='date +"%Y-%m-%d %H:%M:%S %z (%Z)"'
alias datetime-iso='date --iso-8601=seconds'
alias dotfiles='git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME'
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
alias wget="wget --continue --hsts-file=$XDG_STATE_HOME/wget/history"


# Create shorter aliases for various utilities
_command_exists batcat && alias bat='batcat'
_command_exists fdfind && alias fd='fdfind'
_command_exists neofetch && alias nf='neofetch'
_command_exists ranger && alias rn='ranger'
_command_exists screenfetch && alias sf='screenfetch'


# Alias to align commands in ~/.config/i3/config
# Debian/Arch => dex
# Fedora => dex-autostart
_command_exists dex-autostart && alias dex='dex-autostart'
