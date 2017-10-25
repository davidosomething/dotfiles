# lib/plain.sh

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
