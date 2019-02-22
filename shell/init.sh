# init.sh
#
# Sourced on all shells, interactive or not

DKO_SOURCE="${DKO_SOURCE} -> shell/init.sh {"
export DKO_INIT=1

# ============================================================================

. "${HOME}/.dotfiles/shell/vars.sh"
. "${DOTFILES}/shell/os.sh"
. "${DOTFILES}/shell/path.sh"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
