# Dotfiles

This repository contains useful (config) files that I use on my machines.


## Initialization

On a freshly set up machine, run:

```bash
curl https://gitlab.webartifex.biz/alexander/dotfiles/-/raw/main/.config/shell/init_dotfiles.sh \
     > /tmp/init_dotfiles.sh \
  && source /tmp/init_dotfiles.sh
```

This gives you a local copy of the latest version of this repository
    (located in `~/.dotfiles`)
    and initializes all the dotfiles provided here on the system.
Further, `zsh` is set up
    with [`oh-my-zsh`](https://ohmyz.sh/) and [`zplug`](https://github.com/zplug/zplug)
    if it is installed.

**Note**: Log out and in again so that `bash` and `zsh` run as *login* shells.
Otherwise, `~/.profile` is probably *not* sourced.

**Important**: Don't forget to back up your current dotfiles!
