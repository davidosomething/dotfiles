# init.sh

# Sourced on all shells, interactive or not

DKO_SOURCE="${DKO_SOURCE} -> shell/init.sh {"
export DKO_INIT=1

# ============================================================================

. "${HOME}/.dotfiles/shell/vars.sh"

# OS specific overrides
case "$(uname)" in
  Darwin*) . "${DOTFILES}/shell/os-darwin.sh" ;;
  Linux*) . "${DOTFILES}/shell/os-linux.sh" ;;
esac

# Rebuild path starting from system path
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
# shell/vars.sh on the other hand just get inherited.
. "${DOTFILES}/shell/path.sh"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
