# This file is sourced by zsh before ~/.zprofile and ~/.zshrc
# (it's kind of a zsh-only ~/.profile file)


export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"


export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export ZPLUG_HOME="$XDG_DATA_HOME/zplug"
export _Z_DATA="$XDG_DATA_HOME/z"


# Use <Up> key to auto-complete a partially typed command
# TODO: the coloring does not work when zsh-syntax-highlighting is loaded simultaniously
# Source: https://github.com/zsh-users/zsh-history-substring-search/issues/131
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=#ffffff,bg=#38761d,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=#ffffff,bg=#990000,bold"


# Notify about shorter aliases for typed commands
# Source: https://github.com/MichaelAquilina/zsh-you-should-use
export YSU_MESSAGE_POSITION="before"
export YSU_MODE="BESTMATCH"


# Suggest commands as one types
# Source: https://github.com/zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=bold"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# Temporary files should go into ~/.cache
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump-$HOST-$ZSH_VERSION"


# Automatically source ".env" files in folders
# Source: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dotenv
export ZSH_DOTENV_FILE=".env"
