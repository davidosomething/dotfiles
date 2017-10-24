# init.bash
#
# Sourced on all shells, interactive or not
#

DKO_SOURCE="${DKO_SOURCE} -> shell/init.bash {"

# ============================================================================

# Sourced only once, may have been sourced in linux/.xprofile already
. "${HOME}/.dotfiles/shell/xdg.bash"

# Uses XDG base dirs
. "${HOME}/.dotfiles/shell/vars.bash"

# OS specific overrides
case "$OSTYPE" in
  darwin*) . "${DOTFILES}/shell/os-darwin.bash" ;;
  linux*)  . "${DOTFILES}/shell/os-linux.bash" ;;
esac

# Rebuild path starting from system path
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
# shell/vars.bash on the other hand just get inherited.
. "${DOTFILES}/shell/path.bash"

. "${DOTFILES}/shell/helpers.bash"    # scripting helpers

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
