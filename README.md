# Dotfiles

This repository contains useful (config) files that I use on my machines.


## Initialization

On a freshly set up machine, run:

```bash
curl https://gitlab.webartifex.biz/alexander/dotfiles/-/raw/main/.config/shell/init_dotfiles.sh \
     > /tmp/init_dotfiles.sh \
  && source /tmp/init_dotfiles.sh \
  && rm /tmp/init_dotfiles.sh
```

This gives you a local copy of the latest version of this repository
    and replace all dotfiles on the system with the ones provided here.

Don't worry: The current dotfiles are backed up in the `~/.dotfiles.bak` folder!
