# .dotfiles/shell/helpers.bash
# Should be sourced only
#
# Sourced by shell/before.bash
# Helper functions should be sourced AGAIN by any scripts that need it
#

# std logging
# Based on http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
dko::echo_()      { echo -e "    $*"; }

dko::status()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
dko::status_()    { echo -e "\033[0;32m    $*\033[0;m"; }
dko::err()        { echo -e "\033[0;31m==> ERR: \033[0;m$*\033[0;m" >&2; }
dko::err_()       { echo -e           "         $*" >&2; }
dko::warn()       { echo -e "\033[0;33m==> WARN: \033[0;m$*\033[0;m" >&2; }
dko::warn_()      { echo -e           "          $*" >&2; }

dko::usage()      { echo -e "\033[0;34m==> \033[0;34mUSAGE: \033[0;32m$*\033[0;m"; }
dko::usage_()     { echo -e "\033[0;29m    $*\033[0;m"; }

# silently determine existence of executable
# $1 name of bin
dko::has() { command -v "$1" >/dev/null 2>&1; }

# pipe into this to indent
dko::indent() { sed 's/^/    /'; }

# source a file if it exists
# $1 path to file
dko::source() {
  # shellcheck source=/dev/null
  [ -f "$1" ] && . "$1" # && echo "Sourced $1"
}

# require root
dko::requireroot() {
  if [ "$(whoami)" != "root" ]; then
    dko::err "Please run as root, these files go into /etc/**/";
    exit 1
  fi
}

# require executable
# $1 name of bin
dko::require() {
  if dko::has "$1"; then
    dko::status "FOUND: ${1}"
  else
    dko::err "MISSING: ${1}"
    dko::err_ "Please install before proceeding.";
    exit 1
  fi
}

# symlinking helper function
# @TODO don't assume ~/.dotfiles
# $1 source file in $DOTFILES, assuming ${HOME}/.dotfiles
# $2 dest file relative to $HOME
dko::symlink() {
  local dotfiles_dir="${HOME}/.dotfiles"
  local dotfile="${dotfiles_dir}/${1}"
  local homefile="$2"
  local homefilepath="${HOME}/${homefile}"

  dko::status "Symlinking \033[0;35m${homefile}\033[0;32m -> \033[0;35m${dotfile}\033[0;32m "
  mkdir -p "$(dirname "$homefilepath")"
  ln -fns "$dotfile" "$homefilepath"
}
