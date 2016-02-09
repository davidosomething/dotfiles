# Arch Linux

## Hosts File

Flipped the `localhost` and `localhost.localdomain` entries around, for some
reason Selenium has trouble accessing `localhost` when `localhost.localdomain`
is first.

## VirtualBox in Arch

- Add arch packages
  - virtualbox
  - virtualbox-host-modules
  - net-tools
  - vagrant
  - nss-mdns
  - avahi
    - start and enable avahi-dnsconfd service
- Enable vboxdrv, vboxnetadp, and vboxnetflt kernel modules
- Add user to vboxusers
- Add mdns to hosts line in /etc/nsswitch.conf

## Boot order

### 1

```
uefi/bootloader
  getty (where the startup messages appear)
    gdm OR $SHELL (tty)
```

### 2: gdm

```
gdm
  /etc/gdm/Xsession
    /etc/profile
      /etc/profile.d/*
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

