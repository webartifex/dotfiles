# Configuration for `mackup`

This folder contains various **config** files
    to make [`mackup`](https://github.com/lra/mackup)
    synchronize (dot) files the general public should *not* see.
Their format is described [here](https://github.com/lra/mackup/tree/master/doc#add-support-for-an-application-or-almost-any-file-or-directory).


## Changed Location

`mackup`'s default configuration lies the the ~/.mackup.cfg file
    and in the ~/.mackup folder that holds config files with
        custom sync rules not supported "out of the box."

With a "little hack" during the setup of the dotfiles in this repository,
    `mackup`s config files are moved to $XDG_CONFIG_HOME/mackup.
