# .dotfiles/shell/helpers.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/helpers.bash"

__dko_echo_()    { echo "          $*"; }
__dko_status()   { echo "==>       $*"; }
__dko_ok()       { echo "==> OK:   $*"; }
__dko_err()      { echo "==> ERR:  $*" >&2; }
__dko_warn()     { echo "==> WARN: $*" >&2; }
__dko_usage()    { echo "==> USAGE: $*"; }
__dko_status_()  { __dko_echo "$*"; }
__dko_ok_()      { __dko_echo "$*"; }
__dko_err_()     { __dko_echo "$*" >&2; }
__dko_warn_()    { __dko_echo "$*" >&2; }
__dko_usage_()   { __dko_echo "$*"; }

# silently determine existence of executable
# $1 name of bin
__dko_has() { command -v "$1" >/dev/null 2>&1; }

# pipe into this to indent
__dko_indent() { sed 's/^/    /'; }

# source a file if it exists
# $1 path to file
__dko_source() { [ -f "$1" ] && . "$1"; }

# require root
__dko_requireroot() {
  if [ "$(whoami)" != "root" ]; then
    __dko_err "Please run as root, these files go into /etc/**/";
    return 1
  fi
}

# require executable
# $1 name of bin
__dko_require() {
  if __dko_has "$1"; then
    __dko_status "FOUND: ${1}"
  else
    __dko_err "MISSING: ${1}"
    __dko_err_ "Please install before proceeding.";
    return 1
  fi
}
