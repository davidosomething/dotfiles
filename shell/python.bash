# shell/python.bash
#
# uses vars from shell/vars and functions from shell/functions
#

DKO_SOURCE="${DKO_SOURCE} -> shell/python.bash {"

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

export PYENV_ROOT="${HOME}/.local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
dko::has "pyenv" && {
  DKO_SOURCE="${DKO_SOURCE} -> pyenv"
  eval "$(pyenv init -)"
  dko::has "pyenv-virtualenv-init" && eval "$(pyenv virtualenv-init -)"
}

# ==============================================================================
# VirtualEnv for python package isolation
# ==============================================================================

# Default virtualenv
# pipenv compatible!
export WORKON_HOME="${HOME}/.local/venvs"

# Disable auto-add virtualenv name to prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Assign global var to virtualenv name
virtualenv_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
      # Strip out the path and just leave the env name
      venv="${VIRTUAL_ENV##*/}"
  else
      venv=''
  fi
  [[ -n "$venv" ]] && echo "$venv"
}

# ==============================================================================
# pip
# ==============================================================================

dko::has "pip" && {
  if [[ -n "$ZSH_VERSION" ]]; then
    eval "$(pip completion --zsh)"
  elif [[ -n "$BASH" ]]; then
    eval "$(pip completion --bash)"
  fi
}

# ============================================================================
# pipenv
# ============================================================================

dko::has 'pipenv' && eval "$(pipenv --completion)"

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
