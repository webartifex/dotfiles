# This file is sourced by a login shell upon logout

# Clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    if [ -x /usr/bin/clear ]; then
        /usr/bin/clear
    elif [ -x /usr/bin/clear_console ]; then
        /usr/bin/clear_console -q
    fi
fi
