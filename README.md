# dotfiles

> My dotfiles for bash/zsh/vim and others things.

## About

- OSX and ArchLinux compatible
- XDG compliance
- ZSH and BASH compatible
- Try to move as much out of `$HOME` as possible

## Installation

- Clone with submodules, and symlink:

```
git clone --recurse-submodules https://github.com/davidosomething/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/bootstrap
./symlink.sh
```

- (OPTIONAL) Change default shell to zsh and restart now

- Setup vim:

```
cd ~/.dotfiles/bootstrap
./vim.sh
u vim
```

### Working scripts

- `node.sh`
  - installs nvm, node stable, sets default to latest stable

- `symlink.sh`
  - bash, zsh, ack, screen

- `vim.sh`
  - vim

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

Install via nvm, installed via `bootstrap/node.sh` instead of using package
manager.

### Source order

`echo $DKO_SOURCE` to see how files are loaded. It should reflect what's in
`linux/README.md` for openbox. That is:

```
 -> .xprofile -> ob environment -> ob autostart -> zshenv -> shell loader -> zshrc -> shell loader -> shell after
```

For OSX, shells are all login shells so there's probably a `.bash_profile` or
`.zprofile` in there somewhere.

### node-gyp

On arch use python 2 when installing node-gyp:

```
npm config set python /usr/bin/python2.7 -g
```

### pow

The POW gem is no longer used since I have to use Cisco VPN for some things and
there are DNS conflicts.

### vim

Using NeoBundle for vim. NeoBundle will build dependencies where needed, some
system build tools are needed.

See [vim/README.md](https://github.com/davidosomething/dotfiles/blob/master/vim/README.md)

### nm-applet permissions on arch

Ensure policykit allows users in the network access, option 3 here:
https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions

## Not included but I usually use

- Adium theme: http://www.adiumxtras.com/index.php?a=xtras&xtra_id=7014

