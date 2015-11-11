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
cd ~/.dotfiles/bootstrap
./symlink.sh
```

- (OPTIONAL) Change default shell to zsh and restart now

### Working scripts

- `symlink.sh`
  - bash, zsh, ack, screen, (n)vim

- `npm/install.sh`
  - install default packages

- `osx/install.sh`
  - symlink `.hushlogin`

- `ruby/install-default-gems.sh`

- `linux/x11.sh`
  - symlink `.xbindkeysrc`, `.xinitrc`, `.xprofile`

### Homebrew

`brew bundle` will execute all commands in a `Brewfile`. There are several
Brewfiles in the `osx` folder.

## Notes

### Node

Install via nvm, installed via `bin/update npm`, which uses latest git tag
instead of using your system package manager.

### Source order

`echo $DKO_SOURCE` to see how files are loaded. It should reflect what's in
`linux/README.md` for openbox. That is:

    -> .xprofile -> ob environment -> ob autostart
    -> zshenv -> shell loader -> shell before -> zshrc -> shell after

Here's OSX with zsh (remember, OSX is always a login shell):

    -> zshenv -> shell loader -> zprofile -> shell before
    -> zshrc -> shell after

### node-gyp

On arch use python 2 when installing node-gyp:

```shell
npm config set python /usr/bin/python2.7 -g
```

### python

Just remember to never `sudo pip` anything

### pow

The POW gem is no longer used since I have to use Cisco VPN for some things and
there are DNS conflicts.

### vim

See [vim/README.md](https://github.com/davidosomething/dotfiles/blob/master/vim/README.md)

## Not included but I usually use

- Adium theme: http://www.adiumxtras.com/index.php?a=xtras&xtra_id=7014

