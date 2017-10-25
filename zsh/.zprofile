# zsh/.zprofile
#
# Sourced on login shells only
# Sourced after .zshenv and before .zshrc
# macOS always starts a login shell.
#
DKO_SOURCE="${DKO_SOURCE} -> zsh/.zprofile {"
. "${DOTFILES}/shell/dot.profile"
export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
