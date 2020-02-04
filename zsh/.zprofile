# zsh/.zprofile

# Sourced on login shells only
# For linux, the Display Manager (e.g. GDM or SDDM) will source this so things
# will be available to the desktop env
# Sourced after .zshenv and before .zshrc
# macOS always starts a login shell.

export DKO_SOURCE="${DKO_SOURCE} -> zsh/.zprofile {"

if [ -f "/etc/arch-release" ]; then
  . "${HOME}/.dotfiles/shell/dot.profile"
fi

DKO_SOURCE="${DKO_SOURCE} }"
