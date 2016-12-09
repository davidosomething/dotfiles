#!/usr/bin/env bash

set -e

git ls-tree --name-only -r HEAD \
  | xargs -n1 git blame --line-porcelain \
  | grep "^author " \
  | sort \
  | uniq -c \
  | sort -nr

