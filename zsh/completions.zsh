# completions.zsh
#
# fpaths are set in zshenv
# load completion - the -U means look in fpath, -z means on first run
# -i means ignore security errors
#autoload -Uz compinit && compinit -i
# Commented out since this script is sourced before antigen now and antigen
# will do this

# group all by the description above
zstyle ':completion:*' group-name ''

# colorful completion
#zstyle ':completion:*' list-colors ''
# Updated to respect LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' list-dirs-first yes

# use case-insensitive completion if case-sensitive failed generated no hits
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# expand completions as much as possible on tab
# e.g. start expanding a path up to wherever it can be until error
zstyle ':completion:*' expand 'yes'

# don't autocomplete homedirs
zstyle ':completion::complete:cd:*' tag-order '! users'

# in Bold, specify what type the completion is, e.g. a file or an alias or a cmd
zstyle ':completion:*:descriptions' format '%F{black}%B%d%b%f'

# don't complete usernames
zstyle ':completion:*' users ''

# show descriptions for options
zstyle ':completion:*' verbose yes

# Use caching for commands that would like a cache.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR}/.zcache"


# ------------------------------------------------------------------------------
# BASH Compatible completion
# ------------------------------------------------------------------------------
autoload -U +X bashcompinit && bashcompinit

# ------------------------------------------------------------------------------
# WP-CLI
# ------------------------------------------------------------------------------
# bash completion for the `wp` command
# see wp-cli source or oh-my-zsh's variation

_wp_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}

	IFS=$'\n';  # want to preserve spaces at the end
	local opts="$(wp cli completions --line="$COMP_LINE" --point="$COMP_POINT")"

	if [[ "$opts" =~ \<file\>\s* ]]
	then
		COMPREPLY=( $(compgen -f -- $cur) )
	elif [[ $opts = "" ]]
	then
		COMPREPLY=( $(compgen -f -- $cur) )
	else
		COMPREPLY=( ${opts[*]} )
	fi
}
complete -o nospace -F _wp_complete wp

