# Linux specific dotfiles

Some stuff in `x/` can also be used for XQuartz on OSX

## Installation

For openbox, thunar:

```shell
ln -sf ~/.dotfiles/linux/.gtkrc-2.0 ~/.gtkrc-2.0
ln -sf ~/.dotfiles/linux/x/.xprofile ~/.xprofile
ln -sf ~/.dotfiles/linux/x/.xinitrc ~/.xsession
ln -sf ~/.dotfiles/linux/x/.xinitrc ~/.xinitrc
ln -sf ~/.dotfiles/linux/tint2/tint2rc ~/.config/tint2/tint2rc
ln -sf ~/.dotfiles/linux/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
ln -sf ~/.dotfiles/linux/openbox/rc.xml ~/.config/openbox/rc.xml
ln -sf ~/.dotfiles/linux/openbox/menu.xml ~/.config/openbox/menu.xml
ln -sf ~/.dotfiles/linux/openbox/autostart ~/.config/openbox/autostart
ln -sf ~/.dotfiles/linux/nautilus/accels ~/.config/nautilus/accels
```

### nm-applet permissions on arch

Ensure policykit allows users in the network access, option 3 here:
https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions

Also set static DHCP Client Name/ID:
https://wiki.archlinux.org/index.php/NetworkManager#Hostname_problems

### personal keyserver

Enable `keyserver-options auto-key-retrieve` in `~/.gnupg/gpg.conf`
Required for `cower`

### gnome-keyring on boot

Use PAM AND xinitrc instructions from arch wiki.

### GDM

- Give access to X server `xhost +SI:localuser:gdm`

### Thunar

- Extra hidden settings in `thunar.sh`
- User custom actions in `thunar/uca.xml`

### VirtualBox

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

