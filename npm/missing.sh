#!/usr/bin/env bash

installed=$(npm ls --global --parseable --depth=0)
is_missing=0

# loop through packages.txt file and output if not installed
while read package; do
  echo "$installed" | grep -q "$package"
  if [ "$?" != "0" ]; then
    echo "${package} is not installed globally for this version of node"
    is_missing=1
  fi
done < packages.txt

if [ "$is_missing" == "0" ]; then
  echo "No missing packages"
fi
