#!/bin/bash

# autojump from homebrew
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

function mvim() {
  [ ! -f $1 ] && touch $1
  open -a MacVim $@
}

function github() {
  local remotes
  if git remote -v; then
    #remotes="`git remote -v | grep "\(fetch\)$""
    echo "error: No remotes found or not a repository."
  fi
}
