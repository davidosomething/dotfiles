#!/usr/bin/env bash
set -e

#
# Install wp-cli using script
#
if [ ! which wp >/dev/null ]; then
  installing "wp-cli"
  curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash
fi
