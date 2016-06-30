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

# ----------------------------------------------------------------------------
# Move entire dir or file somewhere else
# ----------------------------------------------------------------------------

__move() {
  dko::status "Move ${1} to ${2}"

  if [ ! -d "$1" ] && [ ! -f "$1" ] && [ ! -h "$1" ]; then
    dko::status_ "OK, didn't find ${1}"
    return 0
  fi

  if [ -d "$2" ] || [ -f "$2" ] || [ -h "$2" ]; then
    dko::err  "Not moving ${1} to ${2}, destination already exists."
    dko::err_ "Please resolve conflict manually."
    return 1
  fi

  local dest_parent
  dest_parent="$(dirname "${2}")"
  if [ ! -d "$dest_parent" ]; then
    mkdir -p "$dest_parent" \
      && dko::status_ "Created parent directory ${dest_parent}"
  fi

  mv "$1" "$2" && dko::status_ "Moved ${1} to ${2}"
}

# ----------------------------------------------------------------------------
# Move contents of one dir into another
# ----------------------------------------------------------------------------

__merge_dir() {
  dko::status "Merge ${1} into ${2}"

  if [ ! -d "$1" ]; then
    dko::status_ "OK, didn't find ${1}"
    return 0
  fi

  if [ ! -d "$2" ]; then
    mkdir -p "$2" \
      && dko::status_ "Created dest directory ${2}"
  fi

  mv "${1}/*"   "$2" && dko::status_ "Moved contents of ${1} into ${2}"
  mv "${1}/.*"  "$2" && dko::status_ "Moved .contents in ${1} into ${2}"
  rmdir "$1" && dko::status_ "Removed ${1}"
}

# ----------------------------------------------------------------------------
# Remove file or dir completely with confirmation
# ----------------------------------------------------------------------------

__remove() {
  dko::status "Remove ${1}"

  if [ -f "$1" ] || [ -h "$1" ]; then
    rm -i   "$1" && dko::status_ "Removed file ${1}"
  elif [ -d "$1" ]; then
    rm -ir  "$1" && dko::status_ "Removed directory ${1}"
  else
    dko::status_ "OK, didn't find ${1}"
  fi
}

# ----------------------------------------------------------------------------
# Logic for NVM
# ----------------------------------------------------------------------------

__clean_nvm() {
  dko::status "Move invalid NVM paths"

  if [ "${NVM_DIR}" != "${XDG_CONFIG_HOME}/nvm" ]; then
    dko::err "NVM_DIR not set properly. Should be ${XDG_CONFIG_HOME}/nvm"
    return 1
  fi

  mkdir -p "${NVM_DIR}"

  # Move if wrong place
  __move "${XDG_CONFIG_HOME}/.nvm" "$NVM_DIR"

  # Move if wrong name
  __move "${HOME}/.nvm" "$NVM_DIR"
}

# ============================================================================
# main
# ============================================================================

__move      "${HOME}/.bash_history"   "${BASH_DOTFILES}/.bash_history"
__move      "${HOME}/.composer"       "${XDG_CONFIG_HOME}/composer"
__move      "${HOME}/.gimp-2.8"       "${XDG_CONFIG_HOME}/GIMP/2.8"
__move      "${HOME}/.inputrc"        "${XDG_CONFIG_HOME}/readline/inputrc"
# PYLINTHOME is set
__move      "${HOME}/.pylint.d"       "${XDG_CONFIG_HOME}/pylint"
__merge_dir "${HOME}/.fonts"          "${XDG_DATA_HOME}/fonts"
# HISTFILE is set
# INPUTRC is set

# Removes
# alias points to dotfile
__remove "${HOME}/.mdlrc"
# should be in XDG
__remove "${HOME}/.pulse-cookie"
# should be symlinked in XDG
__remove "${HOME}/.gitconfig"
# should be symlinked in XDG
__remove "${HOME}/.gitignore"

# NVM
__clean_nvm

