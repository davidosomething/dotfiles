# termite terminal emulator

This is my preferred terminal emulator.

When SSH'ing into a remote host, the terminfo is probably not installed.
The bootstrap script `bootstrap/termite.sh` will automatically:

1. symlink the config file
1. run `tic -x xterm-termite.terminfo` to compile and install the terminfo to
   the user's home directory. (See the manpages for `terminfo`, `tic`, and
   `ncurses5-config`)

