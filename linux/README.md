# Linux setup

For openbox, thunar

## Boot order

```
init
  getty
    gdm OR $SHELL

gdm
  /etc/gdm/Xsession
    /etc/.profile
    $HOME/.profile
    $HOME/.xprofile
    /etc/X11/xinit/xinitrc.d/*
    HOME/.xsession
  /usr/bin/openbox-session

startx
  determine which xinitrc
  xinit passed xinitrc
    $HOME/.xinitrc OR /etc/X11/xinit/xinitrc
      /etc/X11/xinit/xinitrc.d/*
      $HOME/.xprofile
      /usr/bin/openbox-session

/usr/bin/openbox-session
  /etc/xdg/openbox/environment
  $HOME/.config/openbox/environment
  /usr/lib/openbox/openbox-autostart
    /etc/xdg/openbox/autostart
    $HOME/.config/openbox/autostart.sh
    /etc/xdg/autostart/*
    openbox
```

## Thunar

- Extra hidden settings in `thunar.sh`
- User custom actions in `thunar/uca.xml`

