# dotfiles

> My dotfiles for bash/zsh/vim and others things.

## Installation

Clone RECURSIVELY (including submodules!!) to `~/.dotfiles`

### Working bootstrap scripts

* `symlink.sh`
    * bash, zsh, ack, tmux, screen
* `vim.sh`
    * vim

### Homebrew

`brew bundle` will execute all commands in a `Brewfile`. There's a `Brewfile`
in the `osx` folder.

Notes
-----

Don't forget to setup apache manually for your OS

### bin

### bash

The aliases and functions here should work in ZSH as well, so they're sourced
by the ZSH dotfiles.

### pow

The POW gem is no longer used since I have to use Cisco VPN for some things and
there are DNS conflicts.

### tmux

Included is a compiled binary of Chris Johnsen's reattach-to-user-namespace
that makes tmux work with pbcopy and OSX clipboard copy and paste.
Check out https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard for more or
if you need to recompile.

### vim

Using NeoBundle for vim.

### zsh

Starts with bash config (vars, paths, aliases, functions) and adds its own.
