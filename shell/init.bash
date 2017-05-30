# init.bash
#
# Sourced on all shells, interactive or not
#

export DKO_SOURCE="${DKO_SOURCE} -> init.bash {"

# ============================================================================

# Sourced only once, may have been sourced in linux/.xprofile already
. "${HOME}/.dotfiles/shell/xdg.bash"

# Uses XDG base dirs
. "${HOME}/.dotfiles/shell/vars.bash"

# OS specific overrides
. "${DOTFILES}/shell/os.bash"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
