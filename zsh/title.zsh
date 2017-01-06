# zsh/title.zsh
#
# Set title of terminal emulator
# Requires add-zsh-hook module (should have been autoloaded in .zshrc)
#

export DKO_SOURCE="${DKO_SOURCE} -> title.zsh"

# print -P means use same escape chars as PROMPT
# %n          expands to $USERNAME
# %m          expands to hostname up to first '.'
# %~          expands to directory, replacing $HOME with '~'

# ============================================================================
# Hook handlers
# ============================================================================

# ----------------------------------------------------------------------------
# ansi-compatible
# ----------------------------------------------------------------------------

__dko::zhook::ansi::process() {
  print -n "\ek${1}\e\\"
}

__dko::zhook::ansi::title() {
  local title="%n@%m:%~"
  print -Pn "\e${title}\e\\"
}

__dko::ztitle::ansi() {
  add-zsh-hook preexec  __dko::zhook::ansi::process
  add-zsh-hook precmd   __dko::zhook::ansi::title
  add-zsh-hook chpwd    __dko::zhook::ansi::title
}

# ----------------------------------------------------------------------------
# xterm-compatible
# ----------------------------------------------------------------------------

__dko::zhook::xterm::process() {
  print -n "\e]0;${1}\a"
}

__dko::zhook::xterm::title() {
  local title="%n@%m:%~"
  print -Pn "\e]0;${title}\a"
}

__dko::ztitle::xterm() {
  add-zsh-hook preexec  __dko::zhook::xterm::process
  add-zsh-hook precmd   __dko::zhook::xterm::title
  add-zsh-hook chpwd    __dko::zhook::xterm::title
}

# ============================================================================
# Use title hooks
# ============================================================================

case "${TERM}" in
  rxvt*|xterm*) __dko::ztitle::xterm ;;

  # echos on tmux :<
  #*)            __dko::term::ansi ;;
esac
