# termite terminal emulator

When SSH'ing into a remote host, the terminfo is probably not installed.
The bootstrap script `bootstrap/termite.sh` will automatically symlink the
config file and run `tic -x xterm-termite.terminfo` to compile and install the
terminfo to the user's home directory.

See `man terminfo`, `man tic`, `man ncurses5-config`

