# Executed by bash when a login shell starts

# Mimic bash's default behavior explicitly
if [ -f "$HOME/.bash_login" ]; then
    source "$HOME/.bash_login"
elif [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
else
    source "$HOME/.bashrc"
fi
