# zsh/prompt-vcs.zsh
#
# Version control info for prompts
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt-vcs.zsh"

# Max displayed branch name length before it's truncated with a horizontal
# ellipsis (…). The ellipsis counts toward this total.
DKO_VCS_BRANCH_MAXLEN=40

# "enable" disables everything else, i.e.
#   bzr cdv cvs darcs hg mtn svk svn tla
# are all disabled
zstyle ':vcs_info:*' enable git

# bzr/svn prompt
# zstyle ':vcs_info:(svn|bzr):*'  branchformat      'r%r'
# zstyle ':vcs_info:(svn|bzr):*'  formats           '(%b)'

# git prompt (and git-svn)
zstyle ':vcs_info:git*' get-revision true
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' stagedstr '+'
zstyle ':vcs_info:git*' formats '%F{magenta}(%b%c%u)'
zstyle ':vcs_info:git*' actionformats '%F{magenta}(%m %F{red}→%F{magenta} %b%c%u)'

# Show untracked files
#
# @see <https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples#L155>
# @see <http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#vcs_005finfo-Quickstart>
# $1 message variable name
# $2 formats/actionformats
+vi-git-untracked() {
  # Use an `if` (not a bare `&&` chain) so the function returns 0 even when
  # there are no untracked files. vcs_info runs set-message hooks in sequence
  # and aborts the rest of the chain if one returns non-zero — a failing
  # trailing `grep -q` here would silently skip git-branch-truncate below.
  #
  # Compare the printed value, not just the exit status: in a bare repo
  # `--is-inside-work-tree` exits 0 while printing "false", so an exit-code
  # check would fall through to `git status` and emit "fatal: this operation
  # must be run in a work tree". The redirect also keeps "true"/"false" from
  # leaking into the prompt.
  # Detect untracked files with `git ls-files --others` instead of
  # `git status --porcelain`: ls-files skips the full status machinery, and
  # `head -1` lets git stop at the first untracked file rather than
  # enumerating the entire worktree. This keeps the per-prompt cost low in
  # large repos.
  #
  # `--show-toplevel` doubles as the work-tree guard: it prints nothing (and
  # errors) in a bare repo or outside a work tree, so a non-empty result means
  # we're safely inside one. Anchoring ls-files there with `-C` restores the
  # old repo-wide semantics — otherwise ls-files only sees the CWD and below,
  # so the marker would miss untracked files elsewhere in the repo.
  local toplevel
  toplevel="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ -n "$toplevel" ]] &&
    [[ -n "$(git -C "$toplevel" ls-files --others --exclude-standard | head -1)" ]]; then
    hook_com['staged']+='T'
  fi
  # This will show the marker if there are any untracked files in repo.
  # If instead you want to show the marker only if there are untracked
  # files in $PWD, use:
  #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
}

# Use custom hook to parse merge message in actionformat
#
# @see <http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#vcs_005finfo-Quickstart>
# $1 message variable name
# $2 formats/actionformats
+vi-git-merge-message() {
  if [[ "${hook_com[action_orig]}" == "merge" ]]; then
    # misc_orig is in the format:
    # bd69f0644eb9aa460da5de9ebf72e2e3c04b30f2 Merge branch 'x' (1 applied)

    # get merge_from branch name
    from=$(printf '%s' "${hook_com[misc]}" | awk '{print $4}' | tr -d "'")

    # modify %m
    hook_com[misc]="${from}"
  fi
}

# Truncate long branch names, replacing the overflow with a unicode horizontal
# ellipsis (…). The ellipsis counts toward $DKO_VCS_BRANCH_MAXLEN, so overlong
# names become (maxlen - 1) chars + '…'.
#
# @see <http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#vcs_005finfo-Quickstart>
# $1 message variable name
# $2 formats/actionformats
+vi-git-branch-truncate() {
  local branch="${hook_com[branch]}"
  # Only rewrite %b when it's too long; keep (maxlen - 1) chars to leave room
  # for the ellipsis. zsh string slices are 1-indexed and inclusive on both
  # ends, so [1,N-1] keeps the first N-1 characters.
  if ((${#branch} > DKO_VCS_BRANCH_MAXLEN)); then
    hook_com[branch]="${branch[1,DKO_VCS_BRANCH_MAXLEN-1]}…"
  fi
}

# Register all set-message hooks together. zstyle replaces (does not append)
# when the same context+style is set repeatedly, so they must be listed in a
# single call or earlier hooks get clobbered.
zstyle ':vcs_info:git*+set-message:*' hooks \
  git-untracked git-merge-message git-branch-truncate

__dko_has "vcs_info" && add-zsh-hook "precmd" "vcs_info"
