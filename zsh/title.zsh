# Set title of terminal emulator

# print -P means use same escape chars as PROMPT
# %n          expands to $USERNAME
# %m          expands to hostname up to first '.'
# %~          expands to directory, replacing $HOME with '~'

_ansi_processname() {
  print -n "\ek$1\e\\"
}

_ansi_title() {
  local title="%n@%m:%~"
  print -Pn "\e${title}\e\\"
}

_xterm_processname() {
  print -n "\e]0;$1\a"
}

_xterm_title() {
  local title="%n@%m:%~"
  print -Pn "\e]0;${title}/\a"
}

_term_title() {
  case "${TERM}" in
    screen*|ansi*)
      preexec_functions+=_ansi_processname
      precmd_functions+=_ansi_title
      _ansi_title
      ;;
    xterm*)
      preexec_functions+=_xterm_processname
      precmd_functions+=_xterm_title
      _xterm_title
      ;;
  esac
}

_term_title
