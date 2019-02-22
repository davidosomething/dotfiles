# shell/functions.sh

# RERUNS ON DOTFILE UPDATE

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

mykey() {
  cat "$HOME/.ssh/id_rsa.pub"
  if __dko_has "pbcopy"; then
    pbcopy <"$HOME/.ssh/id_rsa.pub"
  elif __dko_has "xclip"; then
    xclip "$HOME/.ssh/id_rsa.pub"
  fi
}

# ============================================================================
# misc tools
# ============================================================================

weather() {
  curl wttr.in/"${1:-''}"
}
