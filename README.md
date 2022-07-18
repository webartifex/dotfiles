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
    (located in `~/.dotfiles`)
    and initializes all the dotfiles provided here on your system.
Furthermore, `zsh` is set up with [`oh-my-zsh`](https://ohmyz.sh/) and `zplug`.

**Note**: Log out and in again so that `bash` and `zsh` run as *login* shells.
Otherwise, `~/.profile` is probably *not* sourced.

Don't worry: Your current dotfiles are backed up in the `~/.dotfiles.bak` folder!


### Python Development Environments

The develop environments for Python are managed by [`pyenv`](https://github.com/pyenv/pyenv).

To set them up, run:

```bash
install-pyenv && create-or-update-python-envs
```

Several Python binaries are installed.
Additionally, two `virtualenv`s, "interactive" and "utils", are also created:
 - "interactive" is the default environment with *no* libraries installed, and
 - "utils" hosts globally available utilities.

Use `pyenv local ...` to specify a particular Python binary for a project.
