#!/usr/bin/env bash
#
# Basic symlinks, safe to run on any system
#

# ============================================================================
# initialize script and dependencies
# ============================================================================

if [[ -z "$DOTFILES" ]]; then
  cd -- "$(dirname "$0")/.." || exit 1
  DOTFILES="$PWD"
fi
. "${DOTFILES}/lib/helpers.sh"
. "${DOTFILES}/lib/pretty.bash"

# ============================================================================

__dko_has 'pyenv' || {
  __dko_err 'pyenv is not installed'
  exit 1
}

__mac_pyenv_install() {
  local product_version
  local product_minor
  product_version="$(sw_vers -productVersion)"
  product_minor="${product_version%.*}"

  SDKROOT="/Library/Developer/CommandLineTools/SDKs/MacOSX${product_minor}.sdk" \
    MACOSX_DEPLOYMENT_TARGET="$product_minor" \
    pyenv install "$1"
}

__create_neovim_venv() {
  local __versions
  __versions=$(pyenv versions)

  local __venvs
  __venvs=$(pyenv virtualenvs)

  local name="$1"
  local version="$2"

  if grep -q "$name" <<< "$__venvs"; then
    __dko_ok "${name} exists"

  elif ! grep -q "$version" <<< "$__versions"; then
    if [[ "$OSTYPE" == *'arwin'* ]]; then
      __mac_pyenv_install "$version" || return 1
    else
      pyenv install "$version" || return 1
    fi
  fi

  __dko_status "Creating ${name} and installing pynvim"
  pyenv uninstall neovim3
  pyenv virtualenv "$version" "$name" \
    && pyenv activate "$name" \
    && python -m pip install --upgrade pip \
    && python -m pip install pynvim \
    && pyenv deactivate
}

__main() {
  local p3="$1"

  if [[ -z "$p3" ]]; then
    __dko_usage "$0 3.7.7"
    return 1
  fi

  eval "$(pyenv init -)" || return 1
  eval "$(pyenv virtualenv-init -)" || return 1

  __dko_echo "\$PYENV_ROOT=${PYENV_ROOT}"

  local virtualenvwrapperdest
  virtualenvwrapperdest="$(pyenv root)/plugins/pyenv-virtualenvwrapper"
  if [[ ! -d "$virtualenvwrapperdest" ]]; then
    __dko_status "pyenv-virtualenvwrapper plugin installation"
    git clone \
      https://github.com/pyenv/pyenv-virtualenvwrapper.git \
      "$virtualenvwrapperdest"
  fi

  __dko_status "pyenv-virtualenv setup"
  __dko_echo "desired python3: ${p3}"

  __create_neovim_venv "neovim3" "$p3"
}

__main "$@"
