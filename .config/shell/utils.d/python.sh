# This file creates a function to install and update the Python develop environments


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

prepend-to-path () {  # if not already there
    if [ -d "$1" ] ; then
        case :$PATH: in
            *:$1:*) ;;
            *) PATH=$1:$PATH ;;
        esac
    fi
}



# The Python versions pyenv creates (in descending order)
# Important: The first version also holds the "interactive" and "utils" environments
_py3_versions=('3.10.6' '3.9.13' '3.8.13' '3.7.13')
_py2_version='2.7.18'


# Each Python version receives its own copy of black, pipenv, and poetry
# (e.g., to avoid possible integration problems between pyenv and poetry
#  Source: https://github.com/python-poetry/poetry/issues/5252#issuecomment-1055697424)
_py3_site_packages=('black' 'pipenv' 'poetry')


# The pyenv virtualenv "utils" contains some globally available tools (e.g., mackup)
_py3_utils=('leglight' 'mackup' 'youtube-dl')


# Important: this REMOVES the old ~/.pyenv installation
_install_pyenv() {
    echo "(Re-)Installing pyenv"

    # Ensure that pyenv is on the $PATH
    # (otherwise, the pyenv installer emits warnings)
    mkdir -p "$PYENV_ROOT/bin"
    prepend-to-path "$PYENV_ROOT/bin"

    # Remove old pyenv for clean install
    rm -rf "$PYENV_ROOT" >/dev/null

    # Run the official pyenv installer
    curl https://pyenv.run | bash

    # Make pyenv usable after this installation in the same shell session
    _init_pyenv  # defined in ~/.config/shell/utils.sh
}


create-or-update-python-envs() {
    _command_exists pyenv || _install_pyenv

    eval "$(pyenv init --path)"

    # Keep a legacy Python 2.7, just in case
    echo "Installing/updating Python $_py2_version"
    pyenv install --skip-existing $_py2_version
    pyenv rehash  # needed on a first install
    PYENV_VERSION=$_py2_version pip install --upgrade pip setuptools
    PYENV_VERSION=$_py2_version python -c "import sys; print sys.version"

    for version in ${_py3_versions[@]}; do
        echo "Installing/updating Python $version"
        pyenv install --skip-existing $version
        pyenv rehash  # needed on a first install

        # Start the new environment with the latest pip and setuptools versions
        PYENV_VERSION=$version pip install --upgrade pip setuptools
        PYENV_VERSION=$version python -c "import sys; print(sys.version)"

        # Put the specified utilities in the fresh environments or update them
        for lib in ${_py3_site_packages[@]}; do
            PYENV_VERSION=$version pip install --upgrade $lib
        done
    done

    # Create a virtualenv based off the latest Python version to host global utilities
    echo "Installing/updating the global Python utilities"
    pyenv virtualenv $_py3_versions[1] 'utils'
    pyenv rehash  # needed on a first install
    PYENV_VERSION='utils' pip install --upgrade pip setuptools
    for util in ${_py3_utils[@]}; do
        PYENV_VERSION='utils' pip install --upgrade $util
    done

    # Create a virtualenv based off the latest Python version for interactive usage
    echo "Installing/updating the default/interactive Python environment"
    pyenv virtualenv $_py3_versions[1] 'interactive'
    pyenv rehash  # needed on a first install
    PYENV_VERSION='interactive' pip install --upgrade pip setuptools
    # Install some tools to make interactive usage nicer
    PYENV_VERSION='interactive' pip install --upgrade black bpython ipython

    # Put all Python binaries/virtualenvs and the utilities on the $PATH
    pyenv global 'interactive' $_py3_versions 'utils' $_py2_version
}
