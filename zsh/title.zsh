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

__dko_processname_ansi() {
  print -n "\ek$1\e\\"
}

__dko_title_ansi() {
  local title="%n@%m:%~"
  print -Pn "\e${title}\e\\"
}

__dko_processname_xterm() {
  print -n "\e]0;$1\a"
}

__dko_title_xterm() {
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
    preexec_functions+=__dko_processname_xterm
    precmd_functions+=__dko_title_xterm
    chpwd_functions+=__dko_title_xterm
    __dko_title_xterm
    ;;
esac

