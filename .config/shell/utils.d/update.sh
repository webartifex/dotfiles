# This file defines the `update-machine` function that updates basically everything


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}

_in_zsh() {
    [ -n "$ZSH_VERSION" ]
}



_update_apt() {
    _command_exists apt || return

    echo 'Updating apt packages'
    sudo apt update
    sudo apt dist-upgrade
    sudo apt autoremove
    sudo apt clean
}

_update_dnf() {
    _command_exists dnf || return

    echo 'Updating dnf packages'
    sudo dnf upgrade --refresh
    sudo dnf autoremove
    sudo dnf clean all
}

_remove_old_snaps() {
    sudo snap list --all | awk "/disabled/{print $1, $3}" |
        while read snapname revision; do
            sudo snap remove "$snapname" --revision="$revision"
        done
}



# Update local git repositories (mostly ~/repos)
_update_repositories() {
    echo 'Updating repositories'

    cwd=$(pwd)
    cd $REPOS

    # Otherwise the for-loop waites for manual input
    # if it cd's into a folder with a ".env" file
    ZSH_DOTENV_FILE='.do_not_run_dotenv'

    for dir in */; do
        cd "$REPOS/$dir" && echo "Fetching $REPOS/$dir"
        git fetch --all --prune
    done

    ZSH_DOTENV_FILE='.env'

    _command_exists pass && echo "Fetching $HOME/.password-store" && pass git pull
    _update_dotfiles

    cd $cwd
}

# Update the ~/.dotfiles repository
_update_dotfiles() {
    echo "Fetching $HOME/.dotfiles"
    # The `dotfiles` alias is defined in ~/.bashrc at the end of the
    # "Shell Utilities & Aliases" section and can NOT be used here
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME stash --quiet 
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch --all --prune
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull --rebase --quiet
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME stash pop  # --quiet is ignored
}



_update_zsh() {
    _in_zsh || return

    echo 'Updating zsh'
    _update_omz_fork
    _update_zplug
}

_update_omz_fork() {
    _command_exists omz || return

    # In a nutshell, `omz update` pulls the latest origin/master
    # from the original "oh-my-zsh" repo
    omz update

    cwd=$(pwd)
    cd $ZSH

    git checkout --quiet forked  # most likely already the case

    # Keep our personal "oh-my-zsh" fork up-to-date
    # See: https://code.webartifex.biz/alexander/oh-my-zsh
    git rebase --quiet master
    git push --quiet fork forked --force
    git push --quiet fork master

    cd $cwd
}

_update_zplug() {
    _command_exists zplug || return

    zplug update
    zplug install  # ensure newly added plugins in ~/.zshrc are never forgotten
    zplug load
}



_update_python() {
    echo 'Updating the Python tool chain'

    if _command_exists pyenv; then
        pyenv update
        create-or-update-python-envs  # defined in ~/.config/shell/utils.d/python.sh
    fi

    if _command_exists zsh-pip-cache-packages; then
        zsh-pip-clear-cache
        zsh-pip-cache-packages
    fi
}



_restore_gnome() {
    for file in $HOME/.config/gnome-settings/*.ini; do
        dconf load / < $file
    done
}



run-private-scripts() {  # in the Nextcloud
    if [ -d "$HOME/data/getraenkemarkt/shell" ]; then
        for file in $HOME/data/getraenkemarkt/shell/*.sh; do
            source $file
        done
    fi
}



update-machine() {
    sudo --validate || return

    _update_apt
    _update_dnf
    _command_exists flatpak && sudo flatpak update -y && sudo flatpak uninstall --unused
    _command_exists snap && sudo snap refresh && _remove_old_snaps
    _update_repositories
    _update_zsh
    _update_python
    _restore_gnome

    sudo --reset-timestamp
}
