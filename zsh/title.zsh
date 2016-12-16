# zsh/title.zsh
#
# Set title of terminal emulator
#

export DKO_SOURCE="${DKO_SOURCE} -> title.zsh"

# print -P means use same escape chars as PROMPT
# %n          expands to $USERNAME
# %m          expands to hostname up to first '.'
# %~          expands to directory, replacing $HOME with '~'

# ============================================================================
# Handlers
# ============================================================================

__dko::process::ansi() {
  print -n "\ek$1\e\\"
}

__dko::title::ansi() {
  local title="%n@%m:%~"
  print -Pn "\e${title}\e\\"
}

__dko::process::xterm() {
  print -n "\e]0;$1\a"
}

__dko::title::xterm() {
  local title="%n@%m:%~"
  print -Pn "\e]0;${title}/\a"
}

# ============================================================================
# Make sure the references are to the global arrays
# ============================================================================

typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# ============================================================================
# Assign the handlers
# ============================================================================

case "${TERM}" in
  rxvt*|xterm*)
    preexec_functions+=__dko::process::xterm
    precmd_functions+=__dko::title::xterm
    chpwd_functions+=__dko::title::xterm
    __dko::title::xterm
    ;;
esac

