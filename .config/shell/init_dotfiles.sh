# This file sets up the $XDG_DATA_HOME/dotfiles, a bare git repository,
# such that they are available within a user's $HOME as common "dotfiles"


export XDG_DATA_HOME="$HOME/.local/share"  # temporarily set here; mainly set in ~/.profile


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


cd $HOME


# Get the latest ~/.dotfiles, possibly replacing the old ones
rm -rf "$HOME/.dotfiles" >/dev/null
git clone --bare https://code.webartifex.biz/alexander/dotfiles.git "$HOME/.dotfiles"

# Distribute the dotfiles in $HOME
git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
# Dirty Fix: Otherwise `gnupg` emits a warning
[ -d "$XDG_DATA_HOME/gnupg" ] && chmod 700 $XDG_DATA_HOME/gnupg


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


# Disable the creation of ~/.sudo_as_admin_successful
echo 'Defaults !admin_flag' | sudo tee /etc/sudoers.d/disable_admin_note


echo
echo "Probably it's a good idea to restart the shell"
echo "Make sure to start bash or zsh as a login shell the next time"
echo
