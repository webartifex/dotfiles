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


_in_x11 () {
    _result=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type --value)
    if [[ $_result == "x11" ]]; then
        return 0
    else
        return 1
    fi
}

_in_wayland () {
    _result=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type --value)
    if [[ $_result == "wayland" ]]; then
        return 0
    else
        return 1
    fi
}


# Configure the keyboard:
#  - make right alt the compose key, e.g., for German Umlauts
#  - make caps lock a ctrl modifier and Esc key
if _in_x11; then
    setxkbmap us -option 'compose:ralt,caps:ctrl_modifier,lv3:menu_switch'
    _command_exists xcape && xcape -e "Caps_Lock=Escape"
fi


# Load shell utilities and create aliases
for file in $HOME/.config/shell/{utils.d,aliases.d}/*.sh; do
    source $file
done
