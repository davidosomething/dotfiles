# shell/php.bash
export DKO_SOURCE="${DKO_SOURCE} -> shell/php.bash {"

# ==============================================================================
# utility
# ==============================================================================

# PHP version numbers
phpver() {
  php -d display_startup_errors=0 \
    -r 'echo phpversion();' \
    2>/dev/null
}

phpminorver() {
  php -d display_startup_errors=0 \
    -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;" \
    2>/dev/null
}

phpconfdir() {
  phpini="$(php -d display_startup_errors=0 -r 'echo php_ini_loaded_file();' 2>/dev/null)"
  dirname "$phpini"
}

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
