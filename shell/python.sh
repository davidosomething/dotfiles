# shell/python.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/python.sh {"

# Let python guess where to `import` packages, or use pip instead
unset PYTHONPATH

# ==============================================================================
# Pylint
# ==============================================================================

export PYLINTHOME="${XDG_CONFIG_HOME}/pylint"
export PYLINTRC="${DOTFILES}/python/pylintrc"

# ==============================================================================
# pyenv for multiple Python binaries
# ==============================================================================

# init once
__dko_has "pyenv" || {
  export PYENV_ROOT="${XDG_CONFIG_HOME}/pyenv"
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  __dko_has "pyenv" && {
    DKO_SOURCE="${DKO_SOURCE} -> pyenv"
    eval "$(pyenv init -)"
    # should have pyenv-virtualenv plugin if installed via pyenv-installer
    __dko_has "pyenv-virtualenv-init" && eval "$(pyenv virtualenv-init -)"
  }
}

# ==============================================================================
# VirtualEnv for python package isolation
# ==============================================================================

# Default virtualenv
# pipenv compatible!
export WORKON_HOME="${XDG_CONFIG_HOME}/venvs"

# Disable auto-add virtualenv name to prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Assign global var to virtualenv name
virtualenv_info() {
  venv=''
  # Strip out the path and just leave the env name
  [ -n "$VIRTUAL_ENV" ] && venv="${VIRTUAL_ENV##*/}"
  [ -n "$venv" ] && echo "$venv"
}

# ==============================================================================
# pip
# ==============================================================================

__dko_has "pip" && {
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(pip completion --zsh)"
  elif [ -n "$BASH" ]; then
    eval "$(pip completion --bash)"
  fi
}

# ============================================================================
# pipenv
# ============================================================================

__dko_has 'pipenv' && eval "$(pipenv --completion)"

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
