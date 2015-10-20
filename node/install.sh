#!/usr/bin/env bash

# loop through packages.txt file and install each one
while read package; do
  npm install --force -g "$package"
done < packages.txt

