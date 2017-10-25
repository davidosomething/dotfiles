# Source me

# std logging
# Based on http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
__dko_echo_()    { echo -e           "          $*\033[0;m"; }

__dko_status()   { echo -e "\033[0;34m==>       $*\033[0;m"; }
__dko_status_()  { echo -e "\033[0;34m          $*\033[0;m"; }
__dko_ok()       { echo -e "\033[0;32m==> OK:   $*\033[0;m"; }
__dko_ok_()      { echo -e "\033[0;32m==>       $*\033[0;m"; }
__dko_err()      { echo -e "\033[0;31m==> ERR:  $*\033[0;m" >&2; }
__dko_err_()     { echo -e "\033[0;31m          $*\033[0;m" >&2; }
__dko_warn()     { echo -e "\033[0;33m==> WARN: $*\033[0;m" >&2; }
__dko_warn_()    { echo -e "\033[0;33m          $*\033[0;m" >&2; }
__dko_usage()    { echo -e "\033[0;34m==> USAGE: \033[0;32m$*\033[0;m"; }
__dko_usage_()   { echo -e "\033[0;29m    $*\033[0;m"; }
