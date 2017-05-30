# bash/dot.bash_profile
#
# Sourced on login shells only
# macOS always starts a login shell.
# @see http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
#

DKO_SOURCE="${DKO_SOURCE} -> .bash_profile {"
# Use .bashrc exclusively
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
