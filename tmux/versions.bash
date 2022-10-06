#!/usr/bin/env bash

__load() {
  readonly tmux_version
  # remove non-digits, so tmux 3.0a becomes 3.0
  tmux_version="$(tmux -V | sed 's/[^0-9.]*//g')"

  if (( $(echo "$tmux_version >= 2.9" | bc -l) )); then
    tmux source-file "${DOTFILES}/tmux/t2.9.conf"
  elif (( $(echo "$tmux_version >= 2.4" | bc -l) )); then
    tmux source-file "${DOTFILES}/tmux/t2.4.conf"
  elif (( $(echo "$$tmux_version >= 2.1" | bc -l) )); then
    tmux source-file "${DOTFILES}/tmux/t2.conf"
  else
    tmux source-file "${DOTFILES}/tmux/t1.conf"
  fi
}

__load
