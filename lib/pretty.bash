# Source me

reset=$(tput sgr0)

red=$(tput setaf 1 || tput AF 1)
green=$(tput setaf 2 || tput AF 2)
yellow=$(tput setaf 3 || tput AF 3)
blue=$(tput setaf 4 || tput AF 4)
magenta=$(tput setaf 5 || tput AF 5)
# cyan=$(tput setaf 6 || tput AF 6)
white=$(tput setaf 7 || tput AF 7)

# std logging
# Based on http://serverwizard.heroku.com/script/rvm+git
# added error output to stderr
__dko_echo() { printf '          %s%s\n' "$1" "$reset"; }
__dko_status() { printf '%s==>       %s%s\n' "$blue" "$1" "$reset"; }
__dko_status_() { printf '%s          %s%s\n' "$blue" "$1" "$reset"; }
__dko_ok() { printf '%s==> OK:   %s%s\n' "$green" "$1" "$reset"; }
__dko_ok_() { printf '%s==>       %s%s\n' "$green" "$1" "$reset"; }
__dko_err() { printf '%s==> ERR:  %s%s\n' "$red" "$1" "$reset" >&2; }
__dko_err_() { printf '%s          %s%s\n' "$red" "$1" "$reset" >&2; }
__dko_warn() { printf '%s==> WARN: %s%s\n' "$yellow" "$1" "$reset" >&2; }
__dko_warn_() { printf '%s          %s%s\n' "$yellow" "$1" "$reset" >&2; }
__dko_usage() { printf '%s==> USAGE: %s%s%s\n' "$magenta" "$white" "$1" "$reset"; }
__dko_usage_() { printf '%s           %s%s\n' "$magenta" "$1" "$reset"; }
