# Apple Magic Keyboard on Linux

Can be paired with Bluetooth. Turn off, turn on bt, turn on.

## Enable bluetooth in DM login screen

Jump to the `[Policy]` section of `/etc/bluetooth/main.conf`
Look for `AutoEnable`, set it to `true`.

## Getting it to pair with dual/multi-boot OS

To use the same keyboard on both mac and linux on the same machine, [link the
bluetooth device MACs](https://askubuntu.com/questions/948417/how-can-i-use-the-same-bluetooth-keyboard-and-mouse-with-both-macos-and-ubuntu)

Alternate directions on the [Arch Wiki](https://wiki.archlinux.org/index.php/Bluetooth#Dual_boot_pairing)

## Defaulting Fn keys to F# instead of media

Run the [write_hid_apple](./write_hid_apple) script to automatically create
a modprobe conf for this.

See the [Apple Keyboard](https://wiki.archlinux.org/index.php/Apple_Keyboard)
page in ArchWiki for reference.

## Setting modifier keys

- Do not use `shift:both_capslock` -- it (still, Feb 2021) breaks Shift in
  LWGJL.  
   see [LWJGL #28](https://github.com/LWJGL/lwjgl/issues/28)
- Using `ctrl:nocaps` => `Caps Lock as Ctrl`
  - Prefer this over `capslock(ctrl_modifier)` => `Make Caps Lock an
Additional Ctrl` because LWGJL still reads additional ctrl as caps lock.
- `cat /usr/share/X11/xkb/rules/base.lst` for a full list of modifiers.

- KDE's `Input Devices > Keyboard` system settings will tell KDE to run
  a `setxbmap` command (you can see evidence of this if it ever breaks in the
  system logs).
- For the Apple Magic Keyboard 2 the correct keyboard model to pick in the
  dropdown is Apple | Apple.  
  Running `setxkbmap -print -verbose 10` should yield:

  ```plain
  rules:      evdev
  model:      apple
  layout:     us
  variant:    mac
  options:    ctrl:nocaps
  Trying to build keymap using the following components:
  keycodes:   evdev+aliases(qwerty)
  types:      complete
  compat:     complete
  symbols:    pc+us(mac)+inet(evdev)+ctrl(nocaps)
  geometry:   pc(pc104)
  xkb_keymap {
          xkb_keycodes  { include "evdev+aliases(qwerty)" };
          xkb_types     { include "complete"      };
          xkb_compat    { include "complete"      };
          xkb_symbols   { include "pc+us(mac)+inet(evdev)+ctrl(nocaps)"      };
          xkb_geometry  { include "pc(pc104)"     };
  };
  ```

- I manually mirror this setup for all of X11 via
  `/etc/X11/xorg.conf.d/00-keyboard.conf`. The command

  ```sh
  localectl set-x11-keymap us apple mac ctrl:nocaps
  ```

  will generate the conf file automatically.
