# All git aliases (with < 7 characters) become shell aliases with a "g" prefix


_command_exists() {
    command -v "$1" 1>/dev/null 2>&1
}


if _command_exists git; then
    alias g='git'

    for al in $(git internal-aliases); do
        [ ${#al} -lt 7 ] && eval "alias g$al='git $al'"
    done

    # Check if a 'main' branch exists in place of a 'master' branch
    git_main_branch() {
        if [[ -n "$(git branch --list main)" ]]; then
           echo 'main'
        else
           echo 'master'
        fi
    }
fi
