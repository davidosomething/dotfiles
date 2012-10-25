dotfiles
========

My dotfiles for zsh and others things.

Installation
------------

Run the bootstrap.sh script to set up a terminal and some programs exactly like mine.

If you want a oneliner:

```
$ curl -s -o davidosomething-dotfiles.zsh https://raw.github.com/davidosomething/dotfiles/master/bootstrap.zsh && zsh ./davidosomething-dotfiles.zsh && rm davidosomething-dotfiles.zsh
```

If you install the .zshrc and use zsh, you get the "dotfiles" alias. Run this to go through the step-by-step install again, or for more options use:

```
$ dotfiles --help
```

Notes
-----

* Don't forget to setup apache manually

### bin

The ``` github-flavored-markdown.rb ``` script is for Marked.app

### bash

The aliases and functions here should work in ZSH as well, so they're sourced
by the ZSH dotfiles.

### pow

The .powconfig file allows pow to work with apache.

### tmux

Included is a compiled binary of Chris Johnsen's reattach-to-user-namespace
that makes tmux work with pbcopy and OSX clipboard copy and paste.
Check out https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard for more or
if you need to recompile.

### vim

Using vundler for vim.

### zsh

Starts with bash config (vars, paths, aliases, functions) and adds its own.
