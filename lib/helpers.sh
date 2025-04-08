# shellcheck shell=sh
# ============================================================================
# POSIX-compliant helper scripts
# ============================================================================

# silently determine existence of executable
# $1 name of bin
__dko_has() { command -v "$1" >/dev/null 2>&1; }

__dko_prefer() {
  __dko_has "$1" && return 0
  printf "==> WARN: %s not found\n" "$1"
  return 1
}

# pipe into this to indent
__dko_indent() { sed 's/^/    /'; }

# require root
__dko_requireroot() {
  [ "$(whoami)" = "root" ] && return 0
  __dko_err "Please run as root, these files go into /etc/**/"
  return 1
}

# require executable
# $1 name of bin
__dko_require() {
  __dko_has "$1" && __dko_status "FOUND: ${1}" && return 0
  __dko_err "MISSING: ${1}"
  __dko_err_ "Please install before proceeding."
  return 1
}
