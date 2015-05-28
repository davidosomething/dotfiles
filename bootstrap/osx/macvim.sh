#!/usr/bin/env bash

set -eu

brew uninstall --force macvim

brew cleanup

brew install \
  --build-from-source \
  --custom-icons \
  --override-system-vim \
  --with-lua \
  --with-python3 \
  macvim

brew linkapps macvim

