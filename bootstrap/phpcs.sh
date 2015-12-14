#!/usr/bin/env bash

set -eu

#
# Install WordPress-Coding-Standards standard for PHP-Code-Sniffer
#

readonly wpcs_repo="https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git"
readonly sources_path="${HOME}/src"
readonly standards_path="/usr/local/etc/php-code-sniffer/Standards"

# brew install php-code-sniffer

mkdir -p "${sources_path}"
git clone -b master "${wpcs_repo}" "${sources_path}/wpcs"
phpcs --config-set installed_paths "${standards_path},${sources_path}/wpcs"

