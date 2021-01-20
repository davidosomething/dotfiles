# shell/python.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/python.sh {"

# Let python guess where to `import` packages, or use pip instead
unset PYTHONPATH

# ============================================================================
# Package settings
# ============================================================================

# python-grip
export GRIPHOME="${XDG_CONFIG_HOME}/grip"

# ==============================================================================
# Pylint
# ==============================================================================

export PYLINTHOME="${XDG_CONFIG_HOME}/pylint"
export PYLINTRC="${DOTFILES}/python/pylintrc"

# ==============================================================================
# pyenv for multiple Python binaries
# ==============================================================================

# init once
export PYENV_ROOT="${XDG_CONFIG_HOME}/pyenv"
PATH="${PYENV_ROOT}/bin:${PATH}"
__dko_has 'pyenv' && {
  DKO_SOURCE="${DKO_SOURCE} -> pyenv"
  eval "$(pyenv init -)"
  # should have pyenv-virtualenv plugin if installed via pyenv-installer
  __dko_has 'pyenv-virtualenv-init' && eval "$(pyenv virtualenv-init -)"
  export PIPX_DEFAULT_PYTHON="${PYENV_ROOT}/shims/python"
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
  [ -n "$venv" ] && printf '%s\n' "$venv"
}

# ============================================================================
# pipenv
# ============================================================================

__dko_has 'pipenv' && eval "$(pipenv --completion)"

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
