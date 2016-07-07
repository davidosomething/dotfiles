#!/usr/bin/env bash

set -eu

brew reinstall \
  --with-custom-icons \
  --with-lua \
  --with-python3 \
  --with-override-system-vim \
  macvim

brew linkapps macvim

