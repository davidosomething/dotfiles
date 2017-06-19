# init.bash
#
# Sourced on all shells, interactive or not
#

DKO_SOURCE="${DKO_SOURCE} -> init.bash {"

# ============================================================================
# Create paths (slow)
# ============================================================================

[ ! -d "${HOME}/.local/bin" ]       && mkdir -p "${HOME}/.local/bin"
[ ! -d "${HOME}/.local/man/man1" ]  && mkdir -p "${HOME}/.local/man/man1"

# ============================================================================

# Sourced only once, may have been sourced in linux/.xprofile already
. "${HOME}/.dotfiles/shell/xdg.bash"

# Uses XDG base dirs
. "${HOME}/.dotfiles/shell/vars.bash"

# OS specific overrides
. "${DOTFILES}/shell/os.bash"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
