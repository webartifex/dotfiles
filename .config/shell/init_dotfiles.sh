# This file initializes the ~/.dotfiles as a bare repository


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


cd $HOME


# Get the latest ~/.dotfiles, possibly replacing the old ones
rm -rf "$HOME/.dotfiles" >/dev/null
git clone --bare https://code.webartifex.biz/alexander/dotfiles.git "$HOME/.dotfiles"

# Distribute the dotfiles in $HOME
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no


if _command_exists zsh; then

    # (Re-)Install oh-my-zsh
    export ZSH="$HOME/.oh-my-zsh"
    rm -rf $ZSH >/dev/null
    # Let's NOT use the main repository but our personal fork
    git clone --origin fork --branch forked https://code.webartifex.biz/alexander/oh-my-zsh.git $ZSH
    cd $ZSH
    git remote add origin https://github.com/ohmyzsh/ohmyzsh.git
    cd $HOME

    # (Re-)Install zplug
    export ZPLUG_HOME="$HOME/.zplug"
    rm -rf $ZPLUG_HOME >/dev/null
    git clone https://github.com/zplug/zplug $ZPLUG_HOME

    # Set up all the zplug plugins (-i so that the new ~/.zshrc is sourced)
    zsh -i -c "zplug install"

fi


echo
echo "Probably it's a good idea to restart the shell"
echo "Make sure to start bash or zsh as a login shell the next time"
echo
