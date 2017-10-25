# shell/php.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/php.sh {"

# ============================================================================
# php-version
# ============================================================================

__dko_source "${DKO_BREW_PREFIX}/opt/php-version/php-version.sh" && {
  DKO_SOURCE="${DKO_SOURCE} -> php-version"
  php-version 7.1
}

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
