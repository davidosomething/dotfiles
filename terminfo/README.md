# Compiled terminfo files

In alphabetically named dirs are the compiled versions of terminfo files for
terminal emulators I use.
Outside of the dirs are uncompiled ones for use via `tic -x`.

## mac OS

On mac OS the `~/.terminfo` dir has subdirectories that use the hexadecimal of
the first letter of the terminfo file. So `terminfo/t/tmux-256color` goes into
`~/.terminfo/74/tmux-256color` (since `hex(t) == 74`).

## Installation

Run `../bootstrap/terminfo.sh`

