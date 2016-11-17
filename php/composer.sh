#!/usr/bin/env bash

set -eu

composer diagnose
composer global require "mkusher/padawan=*"
composer global require "phpmd/phpmd=@stable"
composer global require "phpunit/phpunit=5.5.*"
composer global require "psy/psysh=@stable"
composer global require "sebastian/phpcpd=*"
composer global require "squizlabs/php_codesniffer=*"
