# shellcheck shell=sh
# lib/plain.sh

__dko_echo() { printf '        %s\n' "${1}"; }
__dko_status() { printf '==>       %s\n' "${1}"; }
__dko_ok() { printf '==> OK:   %s\n' "${1}"; }
__dko_err() { printf '==> ERR:  %s\n' "${1}" >&2; }
__dko_warn() { printf '==> WARN: %s\n' "${1}" >&2; }
__dko_usage() { printf '==> USAGE: %s\n' "${1}"; }
__dko_status_() { __dko_echo "${1}"; }
__dko_ok_() { __dko_echo "${1}"; }
__dko_err_() { __dko_echo "${1}" >&2; }
__dko_warn_() { __dko_echo "${1}" >&2; }
__dko_usage_() { __dko_echo "${1}"; }

