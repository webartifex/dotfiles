# Dotfiles

This repository contains useful (config) files.

It is structured into two branches:
- [desktop](https://code.webartifex.biz/alexander/dotfiles/src/branch/desktop)
- [main](https://code.webartifex.biz/alexander/dotfiles/src/branch/main)

`main` contains dotfiles intended to be used on all kinds of machines
    and can be thought of as a "minimal" or "server" version.
`desktop` is (re-)based on top of `main`
    and adds "desktop" related dotfiles (e.g., GNOME stuff).


## Installation

Simply run:

```sh
curl https://code.webartifex.biz/alexander/dotfiles/raw/branch/main/.local/bin/install-dotfiles > install-dotfiles && . ./install-dotfiles && rm ./install-dotfiles
```

or

```
wget https://code.webartifex.biz/alexander/dotfiles/raw/branch/main/.local/bin/install-dotfiles -O install-dotfiles && . ./install-dotfiles && rm ./install-dotfiles
```

This downloads a simple [installation script](.local/bin/install-dotfiles)
    and then executes it.
The script has only one dependency, namely [git](https://git-scm.com).
So, it should not be too hard to get this going.

Normally, I advice against executing shell scripts from the internet,
    but this one is short enough to be read even by beginners.
So, convince yourself that it is not harmful!


## Shells

The config files in this repository are optimized for usage with
    [GNU's Bourne again shell](https://man7.org/linux/man-pages/man1/bash.1.html),
    or `bash` for short,
    and the popular [zsh](https://www.zsh.org/).
