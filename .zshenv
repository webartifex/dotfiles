# This file is sourced by zsh before `~/.zprofile` and `~/.zshrc`
# (it's kind of a zsh-only `~/.profile` file)


# TODO: As of now, this coloring does not work when zsh-syntax-highlighting is loaded simultaniously
# Source: https://github.com/zsh-users/zsh-history-substring-search/issues/131
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=#ffffff,bg=#38761d,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=#ffffff,bg=#990000,bold"

export YSU_MESSAGE_POSITION="after"
export YSU_MODE="BESTMATCH"

export ZSH="$HOME/.oh-my-zsh"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=bold"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump-$HOST-$ZSH_VERSION"

export ZPLUG_HOME="$HOME/.zplug"
