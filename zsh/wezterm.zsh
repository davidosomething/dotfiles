# zsh/wezterm.zsh
#
# Keep $WEZ_TAB_ID warm so bin/e can pick its tab-scoped nvim socket without
# forking wez-tab-id.
#
# The value comes out of the pane -> tab map published by
# wezterm/dko/tabstate.lua. Nothing depends on it: bin/e validates it and
# falls back to wez-tab-id whenever it is missing or stale.
#

export DKO_SOURCE="${DKO_SOURCE} -> wezterm.zsh"

[[ -z "${WEZTERM_PANE}" ]] && return

# No forks in here -- $(<file) is read by zsh itself, and the map is a handful
# of lines
__dko_zhook::wezterm::tab_id() {
  local state_file="${XDG_STATE_HOME:-${HOME}/.local/state}/wezterm-tab-state.txt"
  local line

  unset WEZ_TAB_ID
  [[ -r "$state_file" ]] || return

  for line in ${(f)"$(<$state_file)"}; do
    [[ "$line" == "${WEZTERM_PANE} "* ]] || continue
    export WEZ_TAB_ID="${line#* }"
    return
  done
}

# preexec, not precmd: `wezterm cli move-pane-to-new-tab` retags this pane
# while it sits at an already-drawn prompt, and precmd would not run again
# until after the next command had already inherited the stale value. preexec
# is the last moment before that command is forked.
add-zsh-hook preexec __dko_zhook::wezterm::tab_id

# and once now, for anything a login script runs before the first command
__dko_zhook::wezterm::tab_id
