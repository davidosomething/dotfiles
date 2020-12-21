# ----------------------------------------------------------------------------
# Add env to right parts
# ----------------------------------------------------------------------------

# result:
# |
__dko_prompt::env::separator() {
  [[ "${#__dko_prompt_right_parts}" -ne 0 ]] && {
    __dko_prompt_right_colors+=('%F{blue}')
    __dko_prompt_right_parts+=('|')
  }
}

# result:
# js:
__dko_prompt::env::symbol() {
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=("${1}:")
}

# result:
# 1.2.3
#
# $1 manager program
# $2 optional version compute string -- default to *env style (pyenv style)
# $3 optionsl color compute string -- default to blue
__dko_prompt::env::version() {
  local manager="$1"

  if (( $# > 1 )); then
    local number="$2"
  else
    local open='${$('
    local close="${manager} version-name 2>/dev/null):-sys}"
    local number="${open}${close}"
  fi

  local color="${3:-"%F{blue}"}"
  __dko_prompt_right_colors+=("${color}")
  __dko_prompt_right_parts+=("${number}")
}

# $1 symbol
# $2 manager program
# $3 optional version compute string
# $4 optional color compute string
__dko_prompt::env() {
  __dko_has "$2" || return 1
  __dko_prompt::env::separator
  __dko_prompt::env::symbol "$1"
  (( $# == 2 )) && __dko_prompt::env::version "$2"
  (( $# == 3 )) && __dko_prompt::env::version "$2" "$3"
  (( $# == 4 )) && __dko_prompt::env::version "$2" "$3" "$4"
}

__dko_prompt::env::js::get_version() {
  __nodir="${NVM_BIN/$NVM_DIR\/versions\/node\/v}"
  printf '%s' "${__nodir%\/bin}"
}

__dko_prompt::env::py::get_version() {
  python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))'
}

__dko_prompt::env::py::system() {
  [ -z "$system_py" ] && system_py="$(__dko_prompt::env::py::get_version)"
  printf 'sys(%s)' "$system_py"
}

# virtualenv name if in one
# sys(1.2.3) if using system python
# 1.2.3 if using pyenv version
__dko_prompt::env::py() {
  [ -n "$VIRTUAL_ENV" ] && printf '%s' "${VIRTUAL_ENV##*/}" && return

  local pyenv_version_file="${PYENV_ROOT}/version"
  # Not using pyenv version-name because it opens a slow bash subprocess
  # https://github.com/pyenv/pyenv/blob/c3b17c4bbbeb0069a9528f326d5ebd9262435afb/libexec/pyenv-version-name#L18
  [ ! -f "$pyenv_version_file" ] && {
    __dko_prompt::env::py::system
    return
  }

  declare -a lines
  lines=( "${(@f)"$(<$pyenv_version_file)"}" )
  declare -a grepped
  grepped=( ${(M)lines:#*system*} )
  [ -n "$grepped" ] && {
    __dko_prompt::env::py::system
    return
  }

  __dko_prompt::env::py::get_version
}

dko_prompt::env::init() {
  # Get node version provided by NVM using the env vars instead of calling slow
  # NVM functions
  __dko_prompt::env "js" "nvm" '$(__dko_prompt::env::js::get_version)' \
    '$( [[ "$(__dko_prompt::env::js::get_version)" = "$DKO_DEFAULT_NODE_VERSION" ]] && echo "%F{blue}" || echo "%F{red}")'

  __dko_prompt::env "go" "goenv"

  __dko_prompt::env "j" "jenv"


  __dko_prompt::env "py" "python" '$(__dko_prompt::env::py)'

  __dko_prompt::env "rb" "chruby" '${RUBY_VERSION:-sys}'
}
