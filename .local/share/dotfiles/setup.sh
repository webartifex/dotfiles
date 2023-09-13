# This file sets up the $XDG_DATA_HOME/dotfiles, a bare git repository,
# such that they are available within a user's $HOME as common "dotfiles"


export XDG_BIN_HOME="$HOME/.local/bin"  # temporarily set here; mainly set in ~/.profile
export XDG_DATA_HOME="$HOME/.local/share"  # temporarily set here; mainly set in ~/.profile


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


cd $HOME


# Get the latest $XDG_DATA_HOME/dotfiles, possibly replacing the old ones
rm -rf "$XDG_DATA_HOME/dotfiles" >/dev/null
git clone --bare https://code.webartifex.biz/alexander/dotfiles.git "$XDG_DATA_HOME/dotfiles"

# Distribute the dotfiles in $HOME
git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
# Dirty Fix: Otherwise `gnupg` emits a warning
[ -d "$XDG_DATA_HOME/gnupg" ] && chmod 700 $XDG_DATA_HOME/gnupg


if _command_exists python3; then

    # Set up a Python venv to host the scripts controlling the Elgato keylights in my office
    python3 -m venv $XDG_DATA_HOME/elgato
    $XDG_DATA_HOME/elgato/bin/pip list
    $XDG_DATA_HOME/elgato/bin/pip install --upgrade pip setuptools
    $XDG_DATA_HOME/elgato/bin/pip install leglight

fi


if _command_exists pip; then

    # Ensure `pipx` is installed in the user's local environment
    pip install --upgrade --user pipx

    if [ -d "$HOME/data/getraenkemarkt" ]; then

        # (Re-)Install `mackup` via `pipx` in the user's local environment
        export PIPX_BIN_DIR=$XDG_BIN_HOME
        export PIPX_HOME="$XDG_DATA_HOME/pipx"
        $XDG_BIN_HOME/pipx uninstall mackup
        $XDG_BIN_HOME/pipx install mackup

        # Litte Hack: Make `mackup` respect the XDG directory structure
        sed -in 's/VERSION = \".*\"/VERSION = \"0.999.0\"/g' $HOME/.local/**/mackup/constants.py
        sed -in 's/CUSTOM_APPS_DIR = \"\.mackup\"/CUSTOM_APPS_DIR = \"\.config\/mackup\"/g' $HOME/.local/**/mackup/constants.py
        sed -in 's/MACKUP_CONFIG_FILE = \"\.mackup\.cfg\"/MACKUP_CONFIG_FILE = \"\.config\/mackup\/mackup\.cfg\"/g' $HOME/.local/**/mackup/constants.py

        $XDG_BIN_HOME/mackup restore

    fi

fi


if _command_exists zsh; then

    # Set the $ZDOTDIR in /etc[/zsh]/zshenv if that is not already done
    # Notes:
    #  - must use $HOME as $XDG_CONFIG_HOME is not yet set
    #  - on Fedora, the global config files are not in /etc/zsh but in /etc
    export ZDOTDIR="$HOME/.config/zsh"
    for _file in '/etc/zshenv' '/etc/zsh/zshenv'; do
        if [ -f $_file ]; then
            grep -q -F "export ZDOTDIR" $_file || echo 'export ZDOTDIR="$HOME"/.config/zsh' | sudo tee -a $_file
        fi
    done

    # (Re-)Install oh-my-zsh
    export ZSH="$XDG_DATA_HOME/oh-my-zsh"  # temporarily set here; mainly set in $XDG_CONFIG_HOME/zsh/.zshenv
    rm -rf $ZSH >/dev/null
    # Let's NOT use the main repository but our personal fork
    git clone --origin fork --branch forked https://code.webartifex.biz/alexander/oh-my-zsh.git $ZSH
    cd $ZSH
    git remote add origin https://github.com/ohmyzsh/ohmyzsh.git
    cd $HOME

    # (Re-)Install zplug
    export ZPLUG_HOME="$XDG_DATA_HOME/zplug"  # temporarily set here; mainly set in $XDG_CONFIG_HOME/zsh/.zshenv
    rm -rf $ZPLUG_HOME >/dev/null
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    # Set up all the zplug plugins (-i so that the new $XDG_CONFIG_HOME/zsh/.zshrc is sourced)
    zsh -i -c "zplug install"

fi


# Warn user if ~/.local/pipx already exists
# => As we use the custom $XDG_DATA_HOME/pipx location,
# the user should NOT `pipx`'s default install location as well
if [ -d "$HOME/.local/pipx" ]; then
    echo
    echo "~/.local/pipx already existed!"
    echo "It is recommended to delete this location in favor of $XDG_DATA_HOME/pipx"
    echo
fi


echo
echo "Probably it's a good idea to restart the shell"
echo "Make sure to start bash or zsh as a login shell the next time"
echo
