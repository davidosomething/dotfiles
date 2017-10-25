#!/usr/bin/env bash

# delete empty subdirs
__prune() {
  if [[ -n "$1" ]]; then
    read -r "reply?Prune empty directories: are you sure? [y] "
  else
    local _reply=y
  fi

  [[ "$_reply" = y ]] && find . -type d -empty -delete
}
__prune "$@"
