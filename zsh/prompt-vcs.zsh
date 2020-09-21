# zsh/prompt-vcs.zsh
#
# Version control info for prompts
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt-vcs.zsh"

# "enable" disables everything else, i.e.
#   bzr cdv cvs darcs hg mtn svk svn tla
# are all disabled
zstyle ':vcs_info:*' enable git

# bzr/svn prompt
# zstyle ':vcs_info:(svn|bzr):*'  branchformat      'r%r'
# zstyle ':vcs_info:(svn|bzr):*'  formats           '(%b)'

# git prompt (and git-svn)
zstyle ':vcs_info:git*' get-revision      true
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr       '*'
zstyle ':vcs_info:git*' stagedstr         '+'
zstyle ':vcs_info:git*' formats           '%F{magenta}(%b%c%u)'
zstyle ':vcs_info:git*' actionformats     '%F{magenta}(%m %F{red}→%F{magenta} %b%c%u)'

# Show untracked files
#
# @see <https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples#L155>
# @see <http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#vcs_005finfo-Quickstart>
# $1 message variable name
# $2 formats/actionformats
+vi-git-untracked() {
  git rev-parse --is-inside-work-tree 2>/dev/null \
    && git status --porcelain | grep -q '??' \
    && hook_com[staged]+='T'
    # This will show the marker if there are any untracked files in repo.
    # If instead you want to show the marker only if there are untracked
    # files in $PWD, use:
    #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
}
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

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
zstyle ':vcs_info:git*+set-message:*' hooks git-merge-message

__dko_has "vcs_info" && add-zsh-hook "precmd" "vcs_info"
