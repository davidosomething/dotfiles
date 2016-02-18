# Linux dotfiles

- See [ArchLinux](arch.md)
- See [Openbox](openbox.md) - I switched to gnome3 though, maybe out-of-date

Except for the dotfiles in this directory, the other paths should be symlinked
into `$XDG_CONFIG_HOME`.

## gsettings.sh

This flips some gnome shell settings I like.

## thunar.sh

This flips some thunar settings I like. Only used in Openbox desktop

## startx

My startx (no longer used, I use GDM now) is aliased to

    startx > $DOTFILES/logs/startx.log 2>&1


