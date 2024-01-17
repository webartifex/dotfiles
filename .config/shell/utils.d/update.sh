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
    [ -d $REPOS ] || return

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

    _command_exists pass && [ -d "$XDG_DATA_HOME/pass" ] && echo "Fetching $XDG_DATA_HOME/pass" && pass git pull
    _update_dotfiles

    cd $cwd
}

# Update the $XDG_DATA_HOME/dotfiles repository
_update_dotfiles() {
    echo "Fetching $XDG_DATA_HOME/dotfiles"
    # The `dotfiles` alias is defined in ~/.bashrc at the end of the
    # "Shell Utilities & Aliases" section and can NOT be used here
    git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME stash --quiet 
    git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME fetch --all --prune
    git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME pull --rebase --quiet
    git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME stash pop  # --quiet is ignored
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
    # Note: Without a proper GPG key, the rebasing is done without signing

    # First, check if `gpg` exists and works in general
    # as it might not be set up on some servers
    if _command_exists gpg; then
        gpg --list-keys > /dev/null
        rv=$?
    else
        rv=1
    fi

    if [ $rv -eq 0 ] && [ $(gpg --list-keys | grep "AB5C0E319D77350FBA6CF143344EA5AB10D868E0") ]; then
        git rebase --quiet master
        # Only push a properly rebased and signed fork
        git push --quiet fork forked --force
        git push --quiet fork master
    else
        git -c commit.gpgsign=false rebase --quiet master
    fi

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



restore-gnome() {
    _command_exists dconf || return

    for file in $HOME/.config/gnome-settings/*.ini; do
        dconf load / < $file
    done
}



_fix_locations() {

    # Gnome Seahorse (i.e., "Keyrings") uses ~/.pki by default but also
    # detects $XDG_DATA_HOME/pki if it is there and uses it insead;
    # setting this explicitly via an environment variable is not possible
    if [ -d "$HOME/.pki" ]; then
        if [ -d "$XDG_DATA_HOME/pki" ]; then
            echo "Warning: both $HOME/.pki and $XDG_DATA_HOME/pki exist!"
        else
            mv "$HOME/.pki" "$XDG_DATA_HOME/pki"
        fi
    fi

}



run-private-scripts() {  # in the Nextcloud
    sudo --validate || return

    if [ -d "$HOME/Documents/Getraenkemarkt/Shell" ]; then
        for file in $HOME/Documents/Getraenkemarkt/Shell/*.sh; do
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
    restore-gnome
    _fix_locations
    run-private-scripts

    sudo --reset-timestamp
}
