# zsh/zplug.zsh

# Order of execution of related Ice-mods: atinit -> atpull! -> make'!!' -> mv
# -> cp -> make! -> atclone/atpull -> make -> (plugin script loading) -> src
# -> multisrc -> atload.

export DKO_SOURCE="${DKO_SOURCE} -> zplug.zsh {"

function {
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'

  zplug 'plugins/cp', from:oh-my-zsh
  zplug 'plugins/extract', from:oh-my-zsh

  # my fork of cdbk, ZSH hash based directory bookmarking. No wait!
  export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
  zplug 'davidosomething/cdbk'

  export _ZO_DATA="${XDG_DATA_HOME}/zoxide"
  local zoxide_use='*-x86_64-unknown-linux-musl*'
  local zoxide_load=''
  [ "$DOTFILES_OS" = 'Darwin' ] && zoxide_use='*-x86_64-apple-darwin*'
  zplug 'ajeetdsouza/zoxide', from:gh-r, as:command, \
    use:"$zoxide_use"

  zplug "BurntSushi/ripgrep", from:gh-r, as:command, rename-to:rg

  local delta_use='*-x86_64-unknown-linux-musl*'
  [[ "$DOTFILES_OS" = 'Darwin' ]] && delta_use='*-darwin*'
  zplug "dandavison/delta", from:gh-r, as:command, rename-to:delta, \
    use:"$delta_use"

  zplug 'davidosomething/git-relevant', as:command
  zplug 'davidosomething/git-take', as:command

  zplug 'paulirish/git-recent', as:command

  local bat_use='*-x86_64-unknown-linux-musl*'
  [ "$DOTFILES_OS" = 'Darwin' ] && bat_use='*-x86_64-apple-darwin*'
  zplug "sharkdp/bat", from:gh-r, as:command, rename-to:bat, use:"$bat_use"

  zplug 'sharkdp/fd', from:gh-r, as:command, rename-to:fd

  zplug 'stedolan/jq', from:gh-r, as:command, rename-to:jq

  zplug 'zsh-users/zsh-completions'

  zplug load

  eval "$(zoxide init --no-aliases zsh)"
  alias j=__zoxide_z

  export GIT_PAGER='delta --dark'
  export MANPAGER="sh -c 'col -bx | bat --language man --paging always --style=grid'"
}

DKO_SOURCE="${DKO_SOURCE} }"
