# shell/php.bash

DKO_SOURCE="${DKO_SOURCE} -> shell/php.bash {"

# ============================================================================
# php-version
# ============================================================================

dko::source "${DKO_BREW_PREFIX}/opt/php-version/php-version.sh" && {
  DKO_SOURCE="${DKO_SOURCE} -> php-version"
  php-version 7.1
}

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
