# This file initializes the shell


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


_init_pyenv () {  # used in ~/.config/shell/utils.d/python.sh as well
    _command_exists pyenv || return

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}
_init_pyenv


# Configure the keyboard:
#  - make right alt and menu keys the compose key, e.g., for German Umlauts
#  - make caps lock a ctrl modifier and Esc key
setxkbmap us -option 'compose:menu,compose:ralt,caps:ctrl_modifier'
_command_exists xcape && xcape -e "Caps_Lock=Escape"


# Load shell utilities and create aliases
for file in $HOME/.config/shell/{utils.d,aliases.d}/*.sh; do
    source $file
done
