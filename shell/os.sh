# init.sh
#
# Sourced on all shells, interactive or not

DKO_SOURCE="${DKO_SOURCE} -> shell/os.sh {"

# ============================================================================

# OS specific overrides, OSTYPE is not POSIX so these won't run except in
# modern shells
# shellcheck disable=SC2039
case "$OSTYPE" in
darwin*) . "${DOTFILES}/shell/os-darwin.sh" ;;
linux*) . "${DOTFILES}/shell/os-linux.sh" ;;
esac

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
