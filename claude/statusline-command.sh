#!/usr/bin/env bash
# Claude Code statusLine command
# Mirrors the DKO zsh prompt style: path (git-branch) [model]

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
vim_mode=$(echo "$input" | jq -r '.vim.mode // ""')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten path: replace $HOME with ~
home="$HOME"
short_path="${cwd/#$home/~}"

# Git branch info (skip locks to avoid blocking)
git_branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
    || GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Check for staged/unstaged changes
    staged=""
    unstaged=""
    GIT_OPTIONAL_LOCKS=0 git -C "$cwd" diff --cached --quiet 2>/dev/null || staged="+"
    GIT_OPTIONAL_LOCKS=0 git -C "$cwd" diff --quiet 2>/dev/null || unstaged="*"
    git_branch=" (${branch}${staged}${unstaged})"
  fi
fi

# Vim mode indicator
vim_indicator=""
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    INSERT)      vim_indicator=" \033[44;97m I \033[0m" ;;
    NORMAL)      vim_indicator=" \033[42;30m N \033[0m" ;;
    VISUAL*)     vim_indicator=" \033[43;30m V \033[0m" ;;
  esac
fi

# Context usage
context_str=""
if [ -n "$context_pct" ]; then
  context_str=" [ctx: $(printf '%.0f' "$context_pct")%]"
fi

# Assemble output
# path in yellow, git in magenta, model dimmed
printf "${vim_indicator}"
printf "\033[33m%s\033[0m" "${short_path}"
if [ -n "$git_branch" ]; then
  printf "\033[35m%s\033[0m" "${git_branch}"
fi
if [ -n "$model" ]; then
  printf " \033[2m%s\033[0m" "${model}"
fi
printf "%s" "${context_str}"
printf "\n"
