# shell/functions.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/functions.sh"

# ============================================================================
# Scripting
# ============================================================================

current_shell() {
  ps -p $$ | awk 'NR==2 { print $4 }'
}

# ============================================================================
# Directory
# ============================================================================

# Go to git root
cdr() {
  git rev-parse || return 1
  cd -- "$(git rev-parse --show-cdup)" || return 1
}

# ============================================================================
# dev
# ============================================================================

# Update composer packages without cache
cunt() {
  COMPOSER_CACHE_DIR=/dev/null composer update
}

# ============================================================================
# Archiving
# ============================================================================

# Export repo files to specified dir
gitexport() {
  to_dir="${2:-./gitexport}"
  rsync -a "${1:-./}" "$to_dir" --exclude "$to_dir" --exclude .git
}

# ============================================================================
# Network tools
# ============================================================================

# Copy ssh key to clipboard
mykey() {
  local enc="${1:-id_ed25519}"
  local pubkey="${HOME}/.ssh/${enc}.pub"
  [ ! -f "${pubkey}" ] && {
    (echo >&2 "Could not find public key ${pubkey}")
    exit 1
  }

  if __dko_has "pbcopy"; then
    pbcopy <"$pubkey"
  elif __dko_has "xclip"; then
    xclip "$pubkey"
  fi
}

# ============================================================================
# misc tools
# ============================================================================

weather() {
  curl wttr.in/"${1:-''}"
}
