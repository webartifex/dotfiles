# The utilities defined here allow to create random login credentials


# Generate random passwords that are accepted by most services
genpw() {
    PARSED=$(getopt --quiet --options=acn: --longoptions=alphanum,clip,chars: -- "$@")
    eval set -- "$PARSED"
    SYMBOLS='--symbols'
    CHARS=30
    XCLIP=false
    while true; do
        case "$1" in
            -a|--alphanum)
                SYMBOLS=''
                shift
                ;;
            -c|--clip)
                XCLIP=true
                shift
                ;;
            -n|--chars)
                CHARS=$2
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                break
                ;;
        esac
    done
    PW=$(pwgen --ambiguous --capitalize --numerals --secure $SYMBOLS --remove-chars="|/\\\"\`\'()[]{}<>^~@§$\#" $CHARS 1)
    if [[ $XCLIP == true ]]; then
        echo $PW | xclip -selection c
    else
        echo $PW
    fi
}

alias genpw-alphanum='pwgen --ambiguous --capitalize --numerals --secure 30 1'


# Random email addresses that look like "normal" ones
genemail() {
    PARSED=$(getopt --quiet --options=c --longoptions=clip -- "$@")
    eval set -- "$PARSED"
    XCLIP=false
    while true; do
        case "$1" in
            -c|--clip)
                XCLIP=true
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                break
                ;;
        esac
    done
    FIRST=$(shuf -i 4-5 -n 1)
    LAST=$(shuf -i 8-10 -n 1)

    if _command_exists gpw; then
        USER="$(gpw 1 $FIRST).$(gpw 1 $LAST)@webartifex.biz"
    else
        # Fallback that looks a bit less "normal"
        USER="$(pwgen --no-capitalize --no-numerals --secure $FIRST 1).$(pwgen --no-capitalize --no-numerals --secure $LAST 1)@webartifex.biz"
    fi

    if [[ $XCLIP == true ]]; then
        echo $USER | xclip -selection c
    else
        echo $USER
    fi
}
