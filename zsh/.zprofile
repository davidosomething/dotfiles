# zsh/.zprofile

# Sourced on login shells only
# The Display Manager (e.g. GDM or SDDM) can source this so things will be
# available to the desktop env
# Sourced after .zshenv and before .zshrc
# macOS always starts a login shell.

export DKO_SOURCE="${DKO_SOURCE} -> zsh/.zprofile {"
[ -f "/etc/arch-release" ] && . "${HOME}/.dotfiles/shell/dot.profile"
DKO_SOURCE="${DKO_SOURCE} }"
