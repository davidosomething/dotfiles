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

dko::processname_ansi() {
  print -n "\ek$1\e\\"
}

dko::title_ansi() {
  local title="%n@%m:%~"
  print -Pn "\e${title}\e\\"
}

dko::processname_xterm() {
  print -n "\e]0;$1\a"
}

dko::title_xterm() {
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
    preexec_functions+=dko::processname_xterm
    precmd_functions+=dko::title_xterm
    chpwd_functions+=dko::title_xterm
    dko::title_xterm
    ;;
esac

