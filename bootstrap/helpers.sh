#!/usr/bin/env bash
set -e

# This file should be sourced by any files that need the functions

# Helpers
# http://serverwizard.heroku.com/script/rvm+git
function dkostatus()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
function dkostatus_()    { echo -e "\033[0;32m    $*\033[0;m"; }
function dkoerr()        { echo -e "\033[0;31m==> \033[0;33mERROR: \033[0;31m$*\033[0;m"; }
function dkoerr_()       { echo -e "\033[0;31m    $*\033[0;m"; }
function dkoinstalling() { dkostatus "Installing \033[0;33m$1\033[0;32m..."; }
function dkosymlinking() { dkostatus "Symlinking \033[0;35m$1\033[0;32m -> \033[0;35m$2\033[0;32m "; }
function dkodie()        { dkoerr "$*"; exit 256; }

function dkorequire()    {
  if [ command -v $1 >/dev/null 2>&1 ]; then
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
