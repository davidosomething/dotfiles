# completions.zsh
#
# fpaths are set in zshenv

export DKO_SOURCE="$DKO_SOURCE -> completions.zsh"

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

# REMOVED: Attempted cache invalidation causes more problems than it solves.
# Use caching for commands that would like a cache.
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "${ZDOTDIR}/.zcache"

