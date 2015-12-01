# dotfiles

> My dotfiles for bash/zsh/vim and others things.

## About

- OSX and ArchLinux compatible
- XDG compliance
- ZSH and BASH compatible
- VIM and NeoVim config
- Try to move as much out of `$HOME` as possible

## Installation

- Clone with submodules, and symlink:

```shell
git clone --recurse-submodules https://github.com/davidosomething/dotfiles.git ~/.dotfiles
~/.dotfiles/bootstrap/symlink.sh
```

- (OPTIONAL) Change default shell to zsh and restart now
- (OPTIONAL) Run the other scripts in the next section

### Working scripts in bootstrap/

These will assist in installing things

- `cleanup.sh`
  - Moves some things into their XDG Base Directory suppored dirs

- `symlink.sh`
  - bash, zsh, ack, screen, (n)vim

- `npm/install.sh`
  - requires you set up nvm and install node first
  - install default packages

- `ruby/install-default-gems.sh`
  - requires you set up chruby and install a ruby first

- `osx/install.sh`
  - symlink `.hushlogin`

- `linux/x11.sh`
  - symlink `.xbindkeysrc`, `.xinitrc`, `.xprofile`

## Notes

### Source order

`echo $DKO_SOURCE` to see how files are loaded. It should reflect what's in
`linux/README.md` for openbox. That is:

    -> .xprofile -> ob environment -> ob autostart
    -> zshenv -> shell loader -> shell before -> zshrc -> shell after

Here's OSX with zsh (remember, OSX is always a login shell):

    -> zshenv (set zdotdir) -> zprofile (empty) -> zshrc {
        -> shell/vars { -> shell/xdg }
        -> shell/before {
            -> shell/path
            -> shell/z
        }
    } -> shell/after -> .zshrc.local

### node

Install via nvm, installed via `bin/update npm`, which uses latest git tag
instead of using your system package manager.

#### node-gyp

On arch use python 2 when installing node-gyp:

```shell
npm config set python /usr/bin/python2.7 -g
```

### python

Just remember to never `sudo pip` anything. Set up a virtualenv and pip install
the `python/requirements.txt` file.

### vim

See [vim/README.md](https://github.com/davidosomething/dotfiles/blob/master/vim/README.md)

