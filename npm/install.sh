#!/usr/bin/env bash

# loop through packages.txt file and install each one
while read package; do npm install --global "$package"; done < packages.txt

