#
# detect OS
# Skipped if OS flag was given
#
case $OSTYPE in
  darwin*)  export DOTFILES_OS="osx"
            ;;
  linux*)   export DOTFILES_OS="linux"
            if [ -f /etc/debian_version ]; then
              export DOTFILES_DISTRO="debian"
            fi
            if [ -f /etc/arch-release ]; then
              export DOTFILES_DISTRO="archlinux"
            fi
            ;;
  *)        die "Failed to detect operating system"
            ;;
esac
