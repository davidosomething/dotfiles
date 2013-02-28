#!/bin/bash

set -e

# Helpers
# http://serverwizard.heroku.com/script/rvm+git
function status()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
function status_()    { echo -e "\033[0;32m    $*\033[0;m"; }
function err()        { echo -e "\033[0;31m==> \033[0;33mERROR: \033[0;31m$*\033[0;m"; }
function err_()       { echo -e "\033[0;31m    $*\033[0;m"; }
function installing() { status "Installing \033[0;33m$1\033[0;32m..."; }
function die()        { err "$*"; exit 256; }

function require()    {
  if [ command -v $1 >/dev/null 2>&1 ]; then
    status "FOUND: $1"
  else
    die "missing $1, please install before proceeding.";
  fi
}
