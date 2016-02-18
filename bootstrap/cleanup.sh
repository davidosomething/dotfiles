#!/usr/bin/env bash
set -e

# Cleanup home for XDG compliance

# ============================================================================
# initialize script and dependencies
# ============================================================================

cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"

# ============================================================================
# Cleanup functions
# ============================================================================

__clean_composer() {
  if [ -f "$HOME/.composer" ]; then
    dkostatus_ "Moved .composer"
    mv "$HOME/.composer" "$XDG_CONFIG_HOME/composer"
  fi
}

__clean_gimp() {
  if [ -d "$HOME/.gimp-2.8" ]; then
    dkostatus_ "Moved .gimp-2.8"
    mkdir -p "$XDG_CONFIG_HOME/GIMP"
    mv "$HOME/.gimp-2.8" "$XDG_CONFIG_HOME/GIMP/2.8"
    rmdir "$HOME/.gimp-2.8"
  fi
}

__clean_gitconfig() {
  if [ -f "$HOME/.gitconfig" ]; then
    dkostatus_ "Moved .gitconfig"
    mv "$HOME/.gitconfig" "$XDG_CONFIG_HOME/git/config"
  fi
}

__clean_fonts() {
  if [ -d "$HOME/.fonts" ]; then
    dkostatus_ "Moved .fonts"
    mv "$HOME/.fonts/*" "$XDG_DATA_HOME/fonts"
    rmdir "$HOME/.fonts"
  fi
}

__clean_bash_history() {
  if [ -f "$HOME/.bash_history" ]; then
    dkostatus_ "Moved to and removed $BASH_DOTFILES/.bash_history"
    mv "$HOME/.bash_history" "$BASH_DOTFILES/"
  fi
}

__clean_inputrc() {
  if [ -f "$HOME/.inputrc" ]; then
    dkostatus_ "Moved .inputrc"
    mkdir -p "$XDG_CONFIG_HOME/readline"
    mv "$HOME/.inputrc" "$XDG_CONFIG_HOME/readline/inputrc"
  fi
}

__clean_mdlrc() {
  if [ -f "${HOME}/.mdlrc" ]; then
    rm "$HOME/.mdlrc"
  fi
}

__clean_nvm() {
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
  fi

  dkostatus "Checking for $XDG_CONFIG_HOME/.nvm ..."
  if [ -d "$XDG_CONFIG_HOME/.nvm" ]; then
    dkostatus_ "Moved $XDG_CONFIG_HOME/.nvm"
    mv "$XDG_CONFIG_HOME/.nvm/*" "$NVM_DIR"
    rm -rf "$XDG_CONFIG_HOME/.nvm"
    dkostatus_ "Moved $XDG_CONFIG_HOME/.nvm"
  fi
}


__clean_pulse() {
  if [ -f "$HOME/.pulse-cookie" ]; then
    rm "$HOME/.pulse-cookie"
  fi
}


__clean_pylint() {
  if [ -d "$HOME/.pylint" ]; then
    dkostatus_ "Moved $XDG_CONFIG_HOME/pylint"
    mv "$HOME/.pylint.d" "$XDG_CONFIG_HOME/pylint"
  fi
}



# begin ------------------------------------------------------------------------
dkostatus "Cleaning .bash_history" \
  && __clean_bash_history \
  && dkostatus_ "OK"
dkostatus "Cleaning gimp" \
  && __clean_gimp \
  && dkostatus_ "OK"
dkostatus "Cleaning gitconfig" \
  && __clean_gitconfig \
  && dkostatus_ "OK"
dkostatus "Cleaning fonts" \
  && __clean_fonts \
  && dkostatus_ "OK"
dkostatus "Cleaning inputrc" \
  && __clean_inputrc \
  && dkostatus_ "OK"
dkostatus "Cleaning mdlrc" \
  && __clean_mdlrc \
  && dkostatus_ "OK"
dkostatus "Cleaning NVM dir" \
  && __clean_nvm \
  && dkostatus_ "OK"
dkostatus "Cleaning pulse" \
  && __clean_pulse \
  && dkostatus_ "OK"
dkostatus "Cleaning pylint dir" \
  && __clean_pylint \
  && dkostatus_ "OK"

