# dotfiles

> My dotfiles for bash/zsh/vim and others things.

## Installation

1. Clone and symlink:
    ```
    git clone --recurse-submodules https://github.com/davidosomething/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles/bootstrap
    ./symlink.sh
    ```
2. Restart your shell
3. Setup vim:
    ```
    cd ~/.dotfiles/bootstrap
    ./vim.sh
    u vim
    ```

### Working bootstrap scripts

* `symlink.sh`
    * bash, zsh, ack, tmux, screen
* `vim.sh`
    * vim
* `linux/rbenv.sh`

### Homebrew

`brew bundle` will execute all commands in a `Brewfile`. There are several
Brewfiles in the `osx` folder.

## Notes

Don't forget to setup apache manually for your OS

### bin

### bash

The aliases and functions here should work in ZSH as well, so they're sourced by the ZSH dotfiles.

### pow

The POW gem is no longer used since I have to use Cisco VPN for some things and there are DNS conflicts. 

### rbenv

On linux, rbenv should be installed from source. The apt repositories don't provide the latest versions of ruby. `bootstrap/linux/rbenv.sh` does this.

There's a `rbenv/default-gems` file which specifies default gems to install
when switching rubies. Symlink this to ~/.rbenv

### tmux

Included is a compiled binary of Chris Johnsen's reattach-to-user-namespace
that makes tmux work with pbcopy and OSX clipboard copy and paste.
Check out https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard for more or
if you need to recompile.

### vim

Using NeoBundle for vim.
NeoBundle will build dependencies where needed, e.g. for YouCompleteMe, so some system build tools are needed.

### zsh

Augments the bash config (vars, paths, aliases, functions) and adds its own.
