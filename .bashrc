#!/bin/bash

# `bash`-specific configurations


# Load configuration files common to all kinds of shells,
# if not already done by a `bash` login shell
[ -z "$PROFILE_LOADED" ] && [ -f "$HOME/.profile" ] && . "$HOME/.profile"
