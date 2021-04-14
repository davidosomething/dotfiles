# shell/os-linux.bash

# Linux and BSD

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-linux.bash"

case "$(uname -s)" in
FreeBSD) export DOTFILES_OS="FreeBSD" ;;
OpenBSD) export DOTFILES_OS="OpenBSD" ;;
*)
  # for pacdiff
  export DIFFPROG="nvim -d"

  # for gnupg
  GPG_TTY="$(tty)"
  export GPG_TTY

  # X11 - for starting via xinit or startx
  export XAPPLRESDIR="${DOTFILES}/linux"

  if [ -f /etc/fedora-release ]; then
    export DOTFILES_DISTRO="fedora"
  elif [ -f /etc/debian_version ]; then
    export DOTFILES_DISTRO="debian"
  elif [ -f /etc/arch-release ]; then
    # manjaro too
    export DOTFILES_DISTRO="archlinux"
  elif [ -f /etc/synoinfo.conf ]; then
    export DOTFILES_DISTRO="synology"
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
