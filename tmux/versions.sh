#!/usr/bin/env bash

__load() {
  readonly tmux_version="$(tmux -V | cut -c 6-)"

  if [[ $(echo "$tmux_version >= 2.1" | bc) -eq 1 ]]; then
    tmux source-file "${DOTFILES}/tmux/t2.conf"
  else
    tmux source-file "${DOTFILES}/tmux/t1.conf"
  fi
}

__load
