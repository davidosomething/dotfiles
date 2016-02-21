# Compiled terminfo files

These are the compiled versions of terminfo files for terminal emulators I use.

## Installation

Copy structure as-is to `~/.terminfo`.

Or run the bootstrap script related to the terminal emulator (e.g.
`bootstrap/rxvt.sh` and `bootstrap/termite.sh`)

## Descriptions

- r/rxvt-unicode is for rxvt
- s/screen-it is a modified version of the screen terminfo with italics support
    - see [http://superuser.com/questions/536125/opening-vim-in-tmux-ive-got-fonts-in-bold](http://superuser.com/questions/536125/opening-vim-in-tmux-ive-got-fonts-in-bold)
- t/tmux-256color tmux terminfo with italics support
    - see [https://github.com/tmux/tmux/blob/master/FAQ#L355](https://github.com/tmux/tmux/blob/master/FAQ#L355)
    - this is based on xterm's terminfo with screen's overrides so for
      non-xterm (e.g. rxvt), a different one will probably have to be generated
      (which is why I prefer termite, which uses normal xterm escape codes)
