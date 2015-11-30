#!/usr/bin/env bash
set -e

# Cleanup home for XDG compliance

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source "$bootstrap_path/helpers.sh"


_clean_gimp() {
  if [ -d "$HOME/.gimp-2.8" ]; then
    dkostatus_ "Moved .gimp-2.8"
    mkdir -p "$XDG_CONFIG_HOME/GIMP"
    mv "$HOME/.gimp-2.8" "$XDG_CONFIG_HOME/GIMP/2.8"
    rmdir "$HOME/.gimp-2.8"
  else
    dkostatus_ "OK"
  fi
}

_clean_gitconfig() {
  if [ -f "$HOME/.gitconfig" ]; then
    dkostatus_ "Moved .gitconfig"
    mv "$HOME/.gitconfig" "$XDG_CONFIG_HOME/git/config"
  else
    dkostatus_ "OK"
  fi
}

_clean_fonts() {
  if [ -d "$HOME/.fonts" ]; then
    dkostatus_ "Moved .fonts"
    mv "$HOME/.fonts/*" "$XDG_DATA_HOME/fonts"
    rmdir "$HOME/.fonts"
  else
    dkostatus_ "OK"
  fi
}

_clean_bash_history() {
  if [ -f "$HOME/.bash_history" ]; then
    dkostatus_ "Moved to and removed $BASH_DOTFILES/.bash_history"
    mv "$HOME/.bash_history" "$BASH_DOTFILES/"
  else
    dkostatus_ "OK"
  fi
}

_clean_inputrc() {
  if [ -f "$HOME/.inputrc" ]; then
    dkostatus_ "Moved .inputrc"
    mkdir -p "$XDG_CONFIG_HOME/readline"
    mv "$HOME/.inputrc" "$XDG_CONFIG_HOME/readline/inputrc"
  else
    dkostatus_ "OK"
  fi
}

_clean_nvm() {
  if [ "$NVM_DIR" != "$XDG_CONFIG_HOME/nvm" ]; then
    dkoerr "NVM_DIR not set properly. Should be $XDG_CONFIG_HOME/nvm"
    return
  fi

  mkdir -p "$NVM_DIR"

  dkostatus "Checking for $HOME/.nvm ..."
  if [ -d "$HOME/.nvm" ]; then
    dkostatus_ "Moved $HOME/.nvm"
    mv "$HOME/.nvm/*" "$NVM_DIR"
    rm -rf "$HOME/.nvm"
    dkostatus_ "Moved to and removed $HOME/.nvm"
  else
    dkostatus_ "OK"
  fi

  dkostatus "Checking for $XDG_CONFIG_HOME/.nvm ..."
  if [ -d "$XDG_CONFIG_HOME/.nvm" ]; then
    dkostatus_ "Moved $XDG_CONFIG_HOME/.nvm"
    mv "$XDG_CONFIG_HOME/.nvm/*" "$NVM_DIR"
    rm -rf "$XDG_CONFIG_HOME/.nvm"
    dkostatus_ "Moved $XDG_CONFIG_HOME/.nvm"
  else
    dkostatus_ "OK"
  fi
}


_clean_pulse() {
  if [ -f "$HOME/.pulse-cookie" ]; then
    rm "$HOME/.pulse-cookie"
  else
    dkostatus_ "OK"
  fi
}


_clean_pylint() {
  if [ -d "$HOME/.pylint" ]; then
    dkostatus_ "Moved $XDG_CONFIG_HOME/pylint"
    mv "$HOME/.pylint.d" "$XDG_CONFIG_HOME/pylint"
  else
    dkostatus_ "OK"
  fi
}



# begin ------------------------------------------------------------------------
dkostatus "Cleaning .bash_history" && _clean_bash_history
dkostatus "Cleaning gimp" && _clean_gimp
dkostatus "Cleaning gitconfig" && _clean_gitconfig
dkostatus "Cleaning fonts" && _clean_fonts
dkostatus "Cleaning inputrc" && _clean_inputrc
dkostatus "Cleaning NVM dir" && _clean_nvm
dkostatus "Cleaning pulse" && _clean_pulse
dkostatus "Cleaning pylint dir" && _clean_pylint

