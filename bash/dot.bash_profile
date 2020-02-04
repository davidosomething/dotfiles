# bash/dot.bash_profile

# Sourced on login shells only
# Sourced INSTEAD OF ~/.profile
# macOS always starts a login shell.
# @see http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

# @FIXME There are discrepancies on some shells where this is sourced AFTER
# bashrc

export DKO_SOURCE="${DKO_SOURCE} -> bash/dot.bash_profile[login] {"

DOTFILES_OS="$(uname)"
export DOTFILES_OS

this="${BASH_SOURCE[0]}"
if [[ "$OSTYPE" == *'arwin'* ]]; then
  BDOTDIR="$(dirname "$(realpath "$this")")"
else
  BDOTDIR="$(dirname "$(readlink -f "$this")")"
fi
export BDOTDIR

. "$BDOTDIR/dot.bashrc"

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh
