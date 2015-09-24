#!/usr/bin/env bash

# loop through default-gems file and output if not installed
while read gemname; do
  gem list -i "$gemname" >/dev/null
  if [ "$?" != "0" ]; then
    echo "${gemname} not installed"
  fi
done < default-gems

