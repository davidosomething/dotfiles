# .dotfiles/bootstrap/helpers.sh
#
# Helper functions should be sourced by all of the other bootstrapping scripts
# Should be sourced only!
#

# http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
dko::status()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
dko::status_()    { echo -e "\033[0;32m    $*\033[0;m"; }
dko::err()        { echo -e "\033[0;31m==> \033[0;33mERROR: \033[0;31m$*\033[0;m" >&2; }
dko::err_()       { echo -e "\033[0;31m    $*\033[0;m" >&2; }

dko::usage()        { echo -e "\033[0;34m==> \033[0;34mUSAGE: \033[0;32m$*\033[0;m"; }
dko::usage_()       { echo -e "\033[0;29m    $*\033[0;m"; }

dko::installing() { dko::status "Installing \033[0;33m$1\033[0;32m..."; }
dko::symlinking() { dko::status "Symlinking \033[0;35m$1\033[0;32m -> \033[0;35m$2\033[0;32m "; }
dko::die()        { dko::err "$*"; exit 256; }

# silently determine existence of executable
has_program() {
  command -v "$1" >/dev/null 2>&1
}

# pipe into this to indent
dko::indent() {
  sed 's/^/    /'
}

##
# require root
dko::requireroot() {
  if [[ "$(whoami)" != "root" ]]; then
    dko::die "Please run as root, these files go into /etc/**/";
  fi
}

##
# require executable
dko::require() {
  if has_program "$1"; then
    dko::status "FOUND: $1"
  else
    dko::err "MISSING: $1"
    dko::die "Please install before proceeding.";
  fi
}

##
# symlinking helper function
dko::symlink() {
  local dotfiles_dir="${HOME}/.dotfiles"
  local dotfile="${dotfiles_dir}/${1}"
  local homefile="$2"
  local homefilepath="${HOME}/${homefile}"

  mkdir -p "$(dirname "$homefilepath")"
  dko::symlinking "$homefile" "$dotfile" && ln -fns "$dotfile" "$homefilepath"
}

