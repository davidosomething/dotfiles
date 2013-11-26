#!/usr/bin/env bash
#
# Install wp-cli using script
# OSX users should use brew

set -eu

if [ ! which wp >/dev/null ]; then
  curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash
fi
