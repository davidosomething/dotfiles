#!/usr/bin/env bash

set -eu

brew uninstall --force macvim

brew cleanup

brew install ctags ctags-exuberant

# NOTE:
# Added --with-python explicitly even though formula options don't mention it.
# --with-python and --with-python3 are not allowed together
# See formula source instead:
# https://github.com/Homebrew/homebrew/blob/master/Library/Formula/macvim.rb

brew install \
  --with-custom-icons \
  --with-lua \
  --with-python \
  --with-override-system-vim \
  macvim

brew linkapps macvim

