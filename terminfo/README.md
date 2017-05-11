# Compiled terminfo files

In alphabetically named directories are the compiled versions of terminfo
files for terminal emulators I use.
Un-compiled terminfo files exist in the root directory. Install these with
`tic -x`.

## macOS

On macOS the `~/.terminfo` has subdirectories that use the hexadecimal of the
first letter of the terminfo file. So `terminfo/t/tmux-256color` goes into
`~/.terminfo/74/tmux-256color` (since `hex(t) == 74`).

## Installation

Run `../bootstrap/terminfo.sh`

