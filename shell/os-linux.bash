# shell/os-linux.bash
# Linux and BSD

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-linux.bash"

case "$(uname -s)" in
  FreeBSD)   export DOTFILES_OS="FreeBSD" ;;
  OpenBSD)   export DOTFILES_OS="OpenBSD" ;;
  *)
    # for pacdiff
    export DIFFPROG="nvim -d"

    # X11 - for starting via xinit or startx
    export XINITRC="${DOTFILES}/linux/.xinitrc"
    export XAPPLRESDIR="${DOTFILES}/linux"

    if [[ -f "/etc/fedora-release" ]]; then
      export DOTFILES_DISTRO="fedora"
    elif [[ -f "/etc/debian_version" ]]; then
      export DOTFILES_DISTRO="debian"
    elif [[ -f "/etc/arch-release" ]]; then
      export DOTFILES_DISTRO="archlinux"

      # for arch wiki lite, intentionally lowercase
      export wiki_browser="chromium"

      # On ArchLinux, GDM sources the user .Xresources with `-nocpp` so none of the
      # includes are processed. Do a real load here (and leave /etc/gdm/Xsession
      # alone).
      # Setting $XENVIRONMENT is an option, but the -I flag here is more useful.
      # This also lets me keep .Xresources out of ~/
      [[ -n "$DISPLAY" ]] && dko::has "xrdb" && \
        xrdb -merge -I"$DOTFILES" "${DOTFILES}/xresources/.Xresources"
    fi
    ;;
esac
