# Openbox

These files should go into `$XDG_CONFIG_HOME/openbox/`.  
My preferred app stack for Openbox environment:

| component       | purpose     |
| --------------- | ----------- |
| display manager | GDM         |
| compositor      | compton     |
| notifications   | dunst       |
| panel           | tint2       |

## GDM

- Give access to X server `xhost +SI:localuser:gdm`

## Things gnome-session would have otherwise taken care of

### nm-applet permissions on arch

Ensure policykit allows users in the network access, option 3 here:
<https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions>

Also set static DHCP Client Name/ID:
<https://wiki.archlinux.org/index.php/NetworkManager#Hostname_problems>

### gnome-keyring on boot

Use PAM AND xinitrc instructions from arch wiki.

## RC file order

```markdown
/usr/bin/openbox-session
  /etc/xdg/openbox/environment
  $HOME/.config/openbox/environment
  /usr/lib/openbox/openbox-autostart
    /etc/xdg/openbox/autostart
    $HOME/.config/openbox/autostart.sh
    /etc/xdg/autostart/*
    openbox
```

