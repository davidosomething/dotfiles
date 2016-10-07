#!/usr/bin/env bash

set -eu

composer diagnose
composer global require "mkusher/padawan=*"
composer global require "squizlabs/php_codesniffer=*"
