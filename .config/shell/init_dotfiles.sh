# This file initializes the `~/.dotfiles` bare repo
# Source it from either zsh or bash


# Check if a command can be found on the $PATH.
command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


cd $HOME


# This is only here for documentation purposes
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Remove a previous version of a `~/.dotfiles` bare repository
rm -rf "$HOME/.dotfiles" >/dev/null
git clone --bare git@git.webartifex.biz:alexander/dotfiles.git "$HOME/.dotfiles"

# Backup old dotfiles
rm -rf "$HOME/.dotfiles.bak" >/dev/null
mkdir -p $HOME/.dotfiles.bak/.config/{bat,flameshot,git,Nextcloud,pop-system-updater,psql,shell} && \
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} "$HOME/.dotfiles.bak"/{}

# Put new dotfiles in $HOME
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status


# Set up `zsh` only if it is available
# Note: on many servers I use these dotfiles, `zsh` is not installed
if command_exists zsh; then

    # Install oh-my-zsh
    export ZSH="$HOME/.oh-my-zsh"
    rm -rf $ZSH >/dev/null
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH

    # Install zplug
    export ZPLUG_HOME="$HOME/.zplug"
    rm -rf $ZPLUG_HOME >/dev/null
    git clone https://github.com/zplug/zplug $ZPLUG_HOME

    # Set up all the zplug plugins (must be run interacticely
    # so that `~/.zshrc` & friends are sourced again)
    zsh -i -c "zplug install"

fi


echo
echo "Probably it's a good idea to restart the shell"
echo "Make sure to start bash or zsh as a login shell the next time"
echo
