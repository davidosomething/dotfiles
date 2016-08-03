# .zshenv
#
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs
#

export DKO_SOURCE="${DKO_SOURCE} -> zshenv {"

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

source "${HOME}/.dotfiles/shell/vars.sh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"
export HISTFILE="${ZDOTDIR}/.zhistory"

unset ZPLUG_ROOT

export DKO_SOURCE="${DKO_SOURCE} }"
