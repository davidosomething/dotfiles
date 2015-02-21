# dotfiles

> My dotfiles for bash/zsh/vim and others things.

## Installation

* Clone with submodules, and symlink:
    ```
    git clone --recurse-submodules https://github.com/davidosomething/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles/bootstrap
    ./symlink.sh
    ```
* (OPTIONAL) Change and restart shell
* Setup vim:
    ```
    cd ~/.dotfiles/bootstrap
    ./vim.sh
    u vim
    ```

### Working bootstrap scripts

* `symlink.sh`
    * bash, zsh, ack, screen
* `vim.sh`
    * vim

### Homebrew

`brew bundle` will execute all commands in a `Brewfile`. There are several
Brewfiles in the `osx` folder.

## Notes

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

### nm-applet permissions

Ensure policykit allows users in the network access:
https://bbs.archlinux.org/viewtopic.php?id=136202

## Not included but I usually use

* Adium theme: http://www.adiumxtras.com/index.php?a=xtras&xtra_id=7014

