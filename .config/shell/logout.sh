# This file is sourced by a login shell upon logout

# Clear the screen (if desired) to increase privacy
if [ "$SHLVL" = 1 ]; then
    if [ -x /usr/bin/clear ]; then
        read -p "Clear screen? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            /usr/bin/clear
        fi
    elif [ -x /usr/bin/clear_console ]; then
        read -p "Clear screen? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            /usr/bin/clear_console -q
        fi
    fi
fi
