# shellcheck shell=bash
# shell/python.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/python.sh {"

# Let python guess where to `import` packages, or use pip instead
unset PYTHONPATH

# ============================================================================
# Package settings
# ============================================================================

# pip
# https://pip.pypa.io/en/stable/topics/configuration/#pip-config-file
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"

# python-grip
export GRIPHOME="${XDG_CONFIG_HOME}/grip"

# ==============================================================================
# Pylint
# ==============================================================================

export PYLINTHOME="${XDG_CONFIG_HOME}/pylint"
export PYLINTRC="${DOTFILES}/python/pylintrc"

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
