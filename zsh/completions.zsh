##
# completion zstyles
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' expand 'yes'
# don't autocomplete usernames/homedirs
zstyle ':completion::complete:cd::' tag-order '! users' -

##
# tab completion paths
fpath=(
  $ZSH_DOTFILES/zsh-completions/src
  $(brew --prefix)/share/zsh/site-functions
  #  $(brew --prefix)/share/zsh-completions
  $fpath
)
typeset -U fpath

# load completion - the -U means look in fpath, -z means on first run
autoload -Uz compinit && compinit -i
