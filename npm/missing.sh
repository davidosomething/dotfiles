#!/usr/bin/env bash

installed=$(npm ls --global --parseable --depth=0)
is_missing=0

# loop through packages.txt file and output if not installed
while read package; do
  package_name=$(echo "$package" | cut -f1 -d"@")
  echo "$installed" | grep -q "$package_name"
  if [ "$?" != "0" ]; then
    echo "MISSING ${package_name} is not installed globally for this version of node"
    is_missing=1
  else
    echo "  FOUND ${package_name}"
  fi
done < packages.txt

if [ "$is_missing" == "0" ]; then
  echo "No missing packages"
fi
