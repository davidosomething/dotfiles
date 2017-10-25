# bash/dot.bash_profile

# Sourced on login shells only
# Sourced INSTEAD OF ~/.profile, so it sources ~/.profile
# macOS always starts a login shell.
# @see http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

DKO_SOURCE="${DKO_SOURCE} -> .bash_profile {"
. "${BDOTDIR}/dot.bashrc"
export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
