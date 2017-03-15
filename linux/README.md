# Linux dotfiles

- See [ArchLinux](arch.md)
- See [Openbox](../openbox/README.md) - I switched to gnome3 so the Openbox
  readme is a bit out-of-date.

Except for the dotfiles in this directory, the other paths should be symlinked
into `$XDG_CONFIG_HOME`. Only `locale.conf` in this path is COPIED to
`$XDG_CONFIG_HOME/locale.conf` since `/etc/profile.d/locale.sh` checks that
it is a regular file (non-symlink) before sourcing.

## Terminal Emulators

I am using [termite](https://github.com/thestinger/termite) for now. See the
[termite readme](../termite/termite.md).

Terminator and urxvt are good as well, and there are configs for those. All
of the terminal emulators are setup to use the base16-twilight-dark theme, and
probably need `terminfo` installed. Run the bootstrap scripts
[../bootstrap/termite](../bootstrap/termite) or
[../bootstrap/urxvt](../bootstrap/urxvt) to get those installed.

## Other bootstrapping scripts

### ../bootstrap/linux/gsettings

This flips some gnome shell settings I like.

### Deprecated

#### ../bootstrap/linux/thunar

This flips some thunar settings I like. Only used in Openbox desktop so
probably not up to date.

#### startx

My startx (no longer used, I use GDM now) is aliased to

    startx > $DOTFILES/logs/startx.log 2>&1


