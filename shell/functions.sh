# shellcheck shell=bash
# shell/functions.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/functions.sh"

# ============================================================================
# Directory
# ============================================================================

# Go to git root
cdr() {
  git rev-parse || return 1
  cd -- "$(git rev-parse --show-cdup)" || return 1
}

# ============================================================================
# edit upwards
# ============================================================================

eu() {
  end="/"
  gitroot=$(git rev-parse --show-cdup || echo '')
  [ -d "$gitroot" ] && end="$gitroot"
  x=$(pwd)
  while [ "$x" != "$end" ]; do
    result="$(find "$x" -maxdepth 1 -name "$1")"
    [ -f "$result" ] && {
      e "$result"
      return $?
    }
    x=$(dirname "$x")
  done
  return 1
}

# ============================================================================
# dev
# ============================================================================

# git or git status
g() {
  if [ $# -gt 0 ]; then
    git "$@"
  else
    git status --short --branch
  fi
}

xman() {
  xdg-open "man:${1}"
}

# Export repo files to specified dir
gitexport() {
  to_dir="${2:-./gitexport}"
  rsync -a "${1:-./}" "$to_dir" --exclude "$to_dir" --exclude .git
}

# Update composer packages without cache
cunt() {
  COMPOSER_CACHE_DIR=/dev/null composer update
}

killport() {
  command -v gruyere >/dev/null && gruyere && return

  # -t terse, just get pid
  # -i by internet addr
  # -sTCP:LISTEN  only the server listening, not clients connecting/browsers
  #               viewing
  lsof -t -iTCP:"$1" -sTCP:LISTEN | xargs -r kill -9
}

# ============================================================================
# Network tools
# ============================================================================

# Copy ssh key to clipboard
mykey() {
  enc="${1:-id_ed25519}"
  pubkey="${HOME}/.ssh/${enc}.pub"
  [ ! -f "${pubkey}" ] && {
    (echo >&2 "Could not find public key ${pubkey}")
    return 1
  }

  command cat "$pubkey"

  # osc52 is a thing too...
  if __dko_has "pbcopy"; then
    pbcopy <"$pubkey"
    echo "Copied to clipboard using pbcopy"
  elif __dko_has "xsel"; then
    xsel --clipboard <"$pubkey"
    echo "Copied to clipboard using xsel"
  elif __dko_has "xclip"; then
    xclip "$pubkey"
    echo "Copied to clipboard using xclip"
  fi
}

publicip() {
  curl icanhazip.com 2>/dev/null ||
    dig +short @resolver2.opendns.com myip.opendns.com 2>/dev/null
}

# useful for finding things like INSECURE keys (only Ed25519 acceptable)
sshlistkeys() {
  for keyfile in ~/.ssh/id_*; do
    ssh-keygen -l -f "${keyfile}"
  done | uniq
}
