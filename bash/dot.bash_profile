# bash/dot.bash_profile

# Sourced on login shells only
# Sourced INSTEAD OF ~/.profile, so it sources ~/.profile
# macOS always starts a login shell.
# @see http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

# @FIXME There are discrepancies on some shells where this is sourced AFTER
# bashrc

DKO_SOURCE="${DKO_SOURCE} -> .bash_profile {"
. "${HOME}/.dotfiles/shell/dot.profile"
. "${BDOTDIR}/dot.bashrc"
export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh
