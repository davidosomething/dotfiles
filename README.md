dotfiles
========

My dotfiles for zsh and others things.

Installation
------------

Run the install to set up a terminal and some programs exactly like mine.
If you want a oneliner:

```
$ curl -s -o davidosomething-dotfiles.zsh https://raw.github.com/davidosomething/dotfiles/master/bootstrap.zsh && zsh ./davidosomething-dotfiles.zsh && rm davidosomething-dotfiles.zsh
```

Once you've installed the .zshrc file, you get a "dotfiles" alias that will allow you to run commands. Try

```
$ dotfiles --usage
```


Notes
-----

* .zsh*.local.OS files should be sourced from your local, not symlinked
* If using MacPorts, NEVER INSTALL MonoDevelop! It adds /usr/bin/pkg-config .
Touching /usr/bin is filthy.
* Don't forget to setup apache with pow and run the pow install script


tmux
====

Included is a compiled binary of Chris Johnsen's reattach-to-user-namespace
that makes tmux work with pbcopy and OSX clipboard copy and paste.
Check out https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard for more or
if you need to recompile.


VIM dotfiles
============

See `vim/bundle/` for what plugins are installed. Some notes on that:

* vim-surround requires vim-repeat to do dot (.) repeating
