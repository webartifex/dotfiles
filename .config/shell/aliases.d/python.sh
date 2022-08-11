# Make working with Python more convenient


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


# Interactive shells
alias py='python'
alias bpy='bpython'
alias ipy='ipython'


if _command_exists poetry; then
    alias pr='poetry run'
fi


if _command_exists pyenv; then
    alias pyvenvs='pyenv virtualenvs --bare --skip-aliases'
    alias pyver='pyenv version'
    alias pyvers='pyenv versions --skip-aliases'
    alias pywhich='pyenv which'
fi
