# Linux dotfiles

`locale.conf` in this path is COPIED to `${XDG_CONFIG_HOME}/locale.conf` since
`/etc/profile.d/locale.sh` checks if it is a regular file (non-symlink)
before sourcing.

- See [ArchLinux](arch.md)

## Setup

1. Clone repo and run [../bootstrap/symlink](../bootstrap/symlink)
1. Run [../bootstrap/cleanup](../bootstrap/cleanup) to clean up `$HOME` as
   much as possible.
1. I set up iTerm2 to report `TERM=xterm-256color-italic` so if ssh'ing into
   one of my systems, I need to either set it properly or run
   [../bootstrap/terminfo](../bootstrap/terminfo) to copy over my terminfo
   files.
1. Install `zsh` and `lua` (`lua5.1`). Do `chsh -s /bin/zsh` to default to
   zsh.
1. [../bootstrap/install-ripgrep-linux](../bootstrap/install-ripgrep-linux) to
   install ripgrep in most Linux systems.

## Terminal Emulators

I am using [termite](https://github.com/thestinger/termite) for now. See the
[termite readme](../termite/termite.md).

Terminator and urxvt are good as well, and there are configs for those. All
of the terminal emulators are setup to use the base16-twilight-dark theme, and
need `terminfo` installed. Run the bootstrap scripts
[../bootstrap/termite](../bootstrap/termite) or
[../bootstrap/urxvt](../bootstrap/urxvt) to get those installed.

## Other bootstrapping scripts

### ../bootstrap/linux/gsettings

This flips some gnome shell settings I like.
