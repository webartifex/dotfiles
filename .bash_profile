# Executed by bash when a login shell starts

# Mimic bash's default behavior and source `~/.bash_login` next
if [ -f "$HOME/.bash_login" ]; then
    source "$HOME/.bash_login"
else
    source "$HOME/.profile"
fi
