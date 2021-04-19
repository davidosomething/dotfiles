# dot.zshenv

# Symlinked to ~/.zshenv
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs

export DKO_SOURCE="${DKO_SOURCE} -> .zshenv {"

# ============================================================================
# Profiling -- see .zshrc for its execution
# ============================================================================

if [[ "$ITERM_PROFILE" == "PROFILE"* ]] \
  || [[ -n "$DKO_PROFILE_STARTUP" ]]; then
  export DKO_PROFILE_STARTUP="${DKO_PROFILE_STARTUP:-1}"
  echo "==> Profiling ZSH startup"
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  export DKO_PROFILE_LOG="${HOME}/.cache/zlog.$$"
  exec 3>&2 2>"$DKO_PROFILE_LOG"
  setopt xtrace prompt_subst
fi

# ============================================================================
# ZSH settings
# ============================================================================

# using prompt expansion and modifiers to get
#   realpath(dirname(absolute path to this file)
#   https://github.com/filipekiss/dotfiles/commit/c7288905178be3e6c378cc4dea86c1a80ca60660#r29121191
export ZDOTDIR="${${(%):-%N}:A:h}"
export HISTFILE="${HOME}/.local/zsh_history"

# Here so it can be skipped in dot.profile later
# Defines XDG dirs
export DKO_INIT=1
. "${HOME}/.dotfiles/shell/vars.sh"
. "${DOTFILES}/shell/path.sh" # depends on vars
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh
