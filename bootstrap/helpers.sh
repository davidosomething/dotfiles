#!/usr/bin/env bash
#
# Helper functions should be sourced by all of the other bootstrapping scripts

set -e

# http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
dkostatus()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
dkostatus_()    { echo -e "\033[0;32m    $*\033[0;m"; }
dkoerr()        { echo -e "\033[0;31m==> \033[0;33mERROR: \033[0;31m$*\033[0;m" >&2; }
dkoerr_()       { echo -e "\033[0;31m    $*\033[0;m" >&2; }
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
  if [[ $(command -v $1) ]]; then
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
  dkosymlinking $homefile $dotfile && ln -fns $dotfile $HOME/$homefile
}

