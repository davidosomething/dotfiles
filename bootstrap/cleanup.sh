#!/usr/bin/env bash
set -e

# Cleanup home for XDG compliance

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source "$bootstrap_path/helpers.sh"


_clean_nvm() {
  if [ "$NVM_DIR" != "$XDG_CONFIG_HOME/nvm" ]; then
    dkoerr "NVM_DIR not set properly. Should be $XDG_CONFIG_HOME/nvm"
    return
  fi

  mkdir -p "$NVM_DIR"

  dkostatus "Checking for $HOME/.nvm ..."
  if [ -d "$HOME/.nvm" ]; then
    mv "$HOME/.nvm/*" "$NVM_DIR"
    rm -rf "$HOME/.nvm"
    dkostatus_ "Moved to and removed $HOME/.nvm"
  else
    dkostatus_ "OK"
  fi

  dkostatus "Checking for $XDG_CONFIG_HOME/.nvm ..."
  if [ -d "$XDG_CONFIG_HOME/.nvm" ]; then
    mv "$XDG_CONFIG_HOME/.nvm/*" "$NVM_DIR"
    rm -rf "$XDG_CONFIG_HOME/.nvm"
    dkostatus_ "Moved to and removed $XDG_CONFIG_HOME/.nvm"
  else
    dkostatus_ "OK"
  fi
}


# begin ------------------------------------------------------------------------
dkostatus "Cleaning NVM dir"
_clean_nvm

