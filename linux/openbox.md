# Openbox

My preferred app stack for Openbox environment:

| component       | purpose     |
| --------------- | ----------- |
| display manager | GDM         |
| compositor      | compton     |
| filemanager     | thunar      |
| notifications   | dunst       |
| panel           | tint2       |
| terminal        | terminator  |

## nm-applet permissions on arch

Ensure policykit allows users in the network access, option 3 here:
<https://wiki.archlinux.org/index.php/NetworkManager#Set_up_PolicyKit_permissions>

Also set static DHCP Client Name/ID:
<https://wiki.archlinux.org/index.php/NetworkManager#Hostname_problems>

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

## Boot order

Continued from arch.md

### 3: session file - openbox

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

