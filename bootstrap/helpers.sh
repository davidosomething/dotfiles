#!/usr/bin/env bash
#
# Helper functions should be sourced by all of the other bootstrapping scripts

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
pushd "$(dirname "$0")/.." >> /dev/null
dotfiles_path="$(pwd)"
popd >> /dev/null

# http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
dkostatus()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
dkostatus_()    { echo -e "\033[0;32m    $*\033[0;m"; }
dkoerr()        { echo -e "\033[0;31m==> \033[0;33mERROR: \033[0;31m$*\033[0;m" >&2; }
dkoerr_()       { echo -e "\033[0;31m    $*\033[0;m" >&2; }

dkousage()        { echo -e "\033[0;34m==> \033[0;34mUSAGE: \033[0;32m$*\033[0;m"; }
dkousage_()       { echo -e "\033[0;29m    $*\033[0;m"; }

dkoinstalling() { dkostatus "Installing \033[0;33m$1\033[0;32m..."; }
dkosymlinking() { dkostatus "Symlinking \033[0;35m$1\033[0;32m -> \033[0;35m$2\033[0;32m "; }
dkodie()        { dkoerr "$*"; exit 256; }

##
# require root
dkorequireroot() {
  if [[ "$(whoami)" != "root" ]]; then
    dkodie "Please run as root, these files go into /etc/**/";
  fi
}

##
# require executable
dkorequire()    {
  if [[ $(command -v "$1") ]]; then
    dkostatus "FOUND: $1"
  else
    dkodie "missing $1, please install before proceeding.";
  fi
}

##
# symlinking helper function
dkosymlink() {
  local dotfile="$dotfiles_path/$1"
  local homefile="$2"
  dkosymlinking "$homefile" "$dotfile" && ln -fns "$dotfile" "$HOME/$homefile"
}

# silently determine existence of executable
has_program() {
  command -v "$1" >/dev/null 2>&1
}

