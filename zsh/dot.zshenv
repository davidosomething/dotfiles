# dot.zshenv
#
# Symlinked to ~/.zshenv
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs
#

export DKO_SOURCE="${DKO_SOURCE} -> .zshenv {"

# Profiling -- see .zshrc for its execution
export DKO_PROFILE_STARTUP=false
if [[ "$DKO_PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

. "${HOME}/.dotfiles/shell/vars.bash"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"
export HISTFILE="${LDOTDIR}/zsh_history"

# Fix invalid ZPLUG setting if reloading shell
unset ZPLUG_ROOT

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh
