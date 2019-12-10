# shell/os-linux.bash

# Linux and BSD

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-linux.bash"

case "$(uname -s)" in
FreeBSD) export DOTFILES_OS="FreeBSD" ;;
OpenBSD) export DOTFILES_OS="OpenBSD" ;;
*)
  # for pacdiff
  export DIFFPROG="nvim -d"

  # X11 - for starting via xinit or startx
  export XINITRC="${DOTFILES}/linux/.xinitrc"
  export XAPPLRESDIR="${DOTFILES}/linux"

  if [ -f "/etc/fedora-release" ]; then
    export DOTFILES_DISTRO="fedora"
  elif [ -f "/etc/debian_version" ]; then
    export DOTFILES_DISTRO="debian"
  elif [ -f "/etc/arch-release" ]; then
    export DOTFILES_DISTRO="archlinux"
  fi
  ;;
esac

# ============================================================================
# Functions
# ============================================================================

# flush linux font cache
flushfonts() {
  fc-cache -f -v
}
