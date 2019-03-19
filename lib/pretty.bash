# Source me

# std logging
# Based on http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
__dko_echo() { printf '          %s\033[0;m\n' "$1"; }
__dko_status() { printf '\033[0;34m==>       %s\033[0;m\n' "$1"; }
__dko_status_() { printf '\033[0;34m          %s\033[0;m\n' "$1"; }
__dko_ok() { printf '\033[0;32m==> OK:   %s\033[0;m\n' "$1"; }
__dko_ok_() { printf '\033[0;32m==>       %s\033[0;m\n' "$1"; }
__dko_err() { printf '\033[0;31m==> ERR:  %s\033[0;m\n' "$1" >&2; }
__dko_err_() { printf '\033[0;31m          %s\033[0;m\n' "$1" >&2; }
__dko_warn() { printf '\033[0;33m==> WARN: %s\033[0;m\n' "$1" >&2; }
__dko_warn_() { printf '\033[0;33m          %s\033[0;m\n' "$1" >&2; }
__dko_usage() { printf '\033[0;34m==> USAGE: \033[0;32m%s\033[0;m\n' "$1"; }
__dko_usage_() { printf '\033[0;29m           %s\033[0;m\n' "$1"; }
