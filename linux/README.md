# Linux dotfiles

- See [ArchLinux](arch.md)

## Setup

1. Create XDG child directories (run `bootstrap/xdg`). The X Desktop will
   export them in `/etc/xdg/autostart/user-dirs-update-gtk.desktop`.
1. Clone repo and run [bootstrap/symlink](../bootstrap/symlink)
1. Run [bootstrap/cleanup](../bootstrap/cleanup) to clean up `$HOME` as
   much as possible.
1. Install ZSH and set it as the default (ensure its presence in
   `/etc/shells`); restart the terminal and zplugin will self-install
    - Do `chsh -s /bin/zsh` to default to zsh.
1. Install [Fira (Fura) Mono for Powerline](https://github.com/powerline/fonts)
   using the package manager if possible. See instructions in the repo.

## Other bootstrapping scripts

- [bootstrap/install-ripgrep-linux](../bootstrap/install-ripgrep-linux)
  installs ripgrep in most Linux systems.
- [bootstrap/gsettings](../bootstrap/bootstrap/gsettings) flips some gnome
  shell settings I like
