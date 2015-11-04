#!/usr/bin/env bash

# loop through packages.txt file and install each one
while read -r package; do
  npm install --force --save -g "$package"
done < packages.txt

