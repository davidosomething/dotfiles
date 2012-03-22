dotfiles
========

My dotfiles for zsh and others things.

Installation
------------

Run the bootstrap.zsh script to set up a terminal and some programs exactly like mine.
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

* .zsh*.local.OS files should be sourced from your local, not symlinked
* If using MacPorts, NEVER INSTALL MonoDevelop! It adds /usr/bin/pkg-config .
Touching /usr/bin is filthy.
* Don't forget to setup apache with pow and run the pow install script

### pow

The .powconfig file allows pow to work with apache.

### tmux

Included is a compiled binary of Chris Johnsen's reattach-to-user-namespace
that makes tmux work with pbcopy and OSX clipboard copy and paste.
Check out https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard for more or
if you need to recompile.


### vim

See `vim/bundle/` for what plugins are installed. Some notes on that:

* vim-surround requires vim-repeat to do dot (.) repeating

### zsh
