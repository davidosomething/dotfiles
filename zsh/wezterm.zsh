# zsh/wezterm.zsh
#
# Keep $WEZ_TAB_ID warm so bin/e can pick its tab-scoped nvim socket without
# forking wez-tab-id.
#
# The value comes out of the pane -> tab map published by
# wezterm/dko/tabstate.lua, re-read on every prompt so that moving this pane
# to another tab corrects itself. Nothing depends on it: bin/e validates it
# and falls back to wez-tab-id whenever it is missing or stale.
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

add-zsh-hook precmd __dko_zhook::wezterm::tab_id

# first prompt is too late for anything run by a login script
__dko_zhook::wezterm::tab_id
