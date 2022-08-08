# Executed by zsh when a (non-)login shell starts


# Ensure zsh is running interactively
[[ $- != *i* ]] && return



# Enable Powerlevel10k instant prompt
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/p10k-instant-prompt-${(%):-%n}.zsh" ]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# Enable XON/XOFF software flow control
stty -ixon

# Enable colors and change prompt
autoload -Uz colors
colors

# Enable VI mode
bindkey -v

# If an entered command does not exist per se
# but is the name of a folder instead, go there
setopt AUTO_CD

# Treat "#", "~", and "^" as part of patterns for filename generation
setopt EXTENDED_GLOB
# Warn if there are no matches
setopt NO_MATCH

# Silence the shell
setopt NO_BEEP

# Report status of background jobs immediately
setopt NOTIFY

# Remove all "built-in" aliases
unalias -a



# Set these environment variables here (and not in ~/.profile)
# due to conflict/overlap with bash
export HISTFILE="$HOME/.zhistory"  # default name by oh-my-zsh
export HISTSIZE=999999             # number of lines kept in memory
export SAVEHIST=999999             # number of lines kept in $HISTFILE

# Append to the $HISTFILE rather than overwrite it
setopt APPEND_HISTORY



# Initialize oh-my-zsh's plugins

plugins=(
    command-not-found
    dirhistory
    dotenv             # config in ~/.zshenv; `_update_repositories` temporarily disables this
    git-escape-magic
    jsontools
    z
)

source "$ZSH/oh-my-zsh.sh"



# Initialize zplug's plugins

source "$HOME/.zplug/init.zsh"  # config in ~/.zshenv

# Must use double quotes in this section
# Source: https://github.com/zplug/zplug#example

# Make zplug manage itself like a plugin
# Source: https://github.com/zplug/zplug#let-zplug-manage-zplug
zplug "zplug/zplug", hook-build:"zplug --self-manage"

zplug "MichaelAquilina/zsh-you-should-use"  # config in ~/.zshenv

zplug "zsh-users/zsh-autosuggestions"  # config in ~/.zshenv
zplug "zsh-users/zsh-history-substring-search"  # config in ~/.zshenv; there are key bindings below
zplug "zsh-users/zsh-syntax-highlighting"

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug load



# Initialize various utilities and aliases
source "$HOME/.config/shell/utils.sh"
source "$HOME/.config/shell/aliases.sh"



# Initialize zsh's completions

# This is already done via ~/.oh-my-zsh.sh above
# autoload -Uz compinit
# compinit -u -d "$ZSH_COMPDUMP"

# Enable match highlighting and scrolling through long lists,
# and provide a different style of menu completion
zmodload zsh/complist

# Include hidden files in tab completion
_comp_options+=(GLOB_DOTS)

# Enable arrow-key driven interface
zstyle ':completion:*' menu select

# Make compinit find new executables right away
zstyle ':completion:*' rehash true

# Enable grouping and group headers
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''



# Define key bindings

# zsh-autosuggestions plugin
bindkey "^ " autosuggest-accept

# Enable Ctrl-R
bindkey "^R" history-incremental-search-backward

# Use VI keys to navigate the completions in the menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# history-substring-search plugin
# Source: https://github.com/zsh-users/zsh-history-substring-search#usage
# Normal mode
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
# VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down



# Enable Powerlevel10k "full" prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
