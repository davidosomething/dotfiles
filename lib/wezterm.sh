# shellcheck shell=sh
# lib/wezterm.sh

# Find the wezterm CLI.
#
# On Linux bin/get-wezterm drops an AppImage in ~/.local/bin, which is already
# on $PATH. On macOS the app bundle is the whole install and nothing puts
# Contents/MacOS on $PATH. shell/path.sh does, but a script can run from
# launchd, a Claude Code hook, or anything else that never sourced it.
#
# Sets $DKO_WEZTERM to something executable. Returns 1 and sets nothing when
# there is no wezterm to find, so callers can say so instead of no-oping.
__dko_wezterm() {
  [ -n "${DKO_WEZTERM:-}" ] && return 0

  command -v wezterm >/dev/null 2>&1 && {
    DKO_WEZTERM="wezterm"
    return 0
  }

  for __dko_wezterm_candidate in \
    "/Applications/WezTerm.app/Contents/MacOS/wezterm" \
    "${HOME}/Applications/WezTerm.app/Contents/MacOS/wezterm"; do
    [ -x "$__dko_wezterm_candidate" ] && {
      DKO_WEZTERM="$__dko_wezterm_candidate"
      unset __dko_wezterm_candidate
      return 0
    }
  done
  unset __dko_wezterm_candidate

  return 1
}
