# ============================================================================
# FZF keybindings
# ============================================================================

(($+commands[fzf])) && {
  if . "${XDG_CONFIG_HOME}/fzf/fzf.zsh" 2>/dev/null || {
    # linux package managers throw it here
    . "/usr/share/fzf/completion.zsh" 2>/dev/null
    . "/usr/share/fzf/key-bindings.zsh" 2>/dev/null
  } || {
    # apt / debian
    . "/usr/share/doc/fzf/examples/completion.zsh" 2>/dev/null
    . "/usr/share/doc/fzf/examples/key-bindings.zsh" 2>/dev/null
  }; then
    DKO_SOURCE="${DKO_SOURCE} -> fzf"
  fi

  # <A-b> to open git branch menu and switch to one
  # changed from <C-b> since that's my tmux bind
  __dkofzfbranch() {
    fzf-git-branch
    zle accept-line
  }
  zle -N __dkofzfbranch
  bindkey '^[b' __dkofzfbranch

  # <A-w> to open git worktree list and cd into one
  __dkofzfworktree() {
    local wt
    wt="$(fzf-git-worktree)"
    [ -d "$wt" ] && cd "${wt}"
    zle accept-line
  }
  zle -N __dkofzfworktree
  bindkey '^[w' __dkofzfworktree
}
