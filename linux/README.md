# Linux setup

For openbox, thunar

## Boot order

### 1

```
init
  getty
    gdm OR $SHELL
```

### 2: gdm

```
gdm
  /etc/gdm/Xsession
    /etc/profile
    $HOME/.profile
    $HOME/.xprofile
    /etc/X11/xinit/xinitrc.d/*
    $HOME/.xsession
    SESSION FILE
```

### 2: startx

```
startx
  determine which xinitrc
  xinit passed xinitrc
    $HOME/.xinitrc OR /etc/X11/xinit/xinitrc
      /etc/X11/xinit/xinitrc.d/*
      $HOME/.xprofile
      SESSION FILE
```

### 3: session file - openbox

```
/usr/bin/openbox-session
  /etc/xdg/openbox/environment
  $HOME/.config/openbox/environment
  /usr/lib/openbox/openbox-autostart
    /etc/xdg/openbox/autostart
    $HOME/.config/openbox/autostart.sh
    /etc/xdg/autostart/*
    openbox
```

## personal keyserver

Enable `keyserver-options auto-key-retrieve` in `~/.gnupg/gpg.conf`
Required for `cower`

## gnome-keyring on boot

Use PAM AND xinitrc instructions from arch wiki.

## GDM

- Give access to X server `xhost +SI:localuser:gdm`

## Thunar

- Extra hidden settings in `thunar.sh`
- User custom actions in `thunar/uca.xml`

