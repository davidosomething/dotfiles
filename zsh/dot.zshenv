# dot.zshenv

# Symlinked to ~/.zshenv
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs

DKO_SOURCE="${DKO_SOURCE} -> .zshenv {"

# ============================================================================
# Profiling -- see .zshrc for its execution
# ============================================================================

if [[ "$ITERM_PROFILE" == "PROFILE"* ]] \
  || [[ -n "$DKO_PROFILE_STARTUP" ]]; then
  export DKO_PROFILE_STARTUP="${DKO_PROFILE_STARTUP:-1}"
  echo "==> Profiling ZSH startup"
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>"${HOME}/.cache/zlog.$$"
  setopt xtrace prompt_subst
fi

# ============================================================================
# ZSH settings
# ============================================================================

export ZDOTDIR="${HOME}/.dotfiles/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"
export HISTFILE="${HOME}/.local/zsh_history"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh
