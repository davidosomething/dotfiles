dotfiles
========

Run the install to set up a terminal and some programs exactly like mine.

```
curl -o ti.zsh https://raw.github.com/davidosomething/dotfiles/master/install.zsh;zsh ti.zsh;rm ti.zsh
```

Notes:

* If using MacPorts, NEVER INSTALL MonoDevelop! It adds /usr/bin/pkg-config .
Touching /usr/bin is filthy.
