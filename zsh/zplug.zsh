# zsh/zplug.zsh

# Order of execution of related Ice-mods: atinit -> atpull! -> make'!!' -> mv
# -> cp -> make! -> atclone/atpull -> make -> (plugin script loading) -> src
# -> multisrc -> atload.

export DKO_SOURCE="${DKO_SOURCE} -> zplug.zsh {"

function {
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'

  zplug "plugins/cp", from:oh-my-zsh
  zplug "plugins/extract", from:oh-my-zsh

  # my fork of cdbk, ZSH hash based directory bookmarking. No wait!
  export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
  zplug "davidosomething/cdbk"

  export _ZO_DATA="${XDG_DATA_HOME}/zoxide"
  local zoxide_use="*-x86_64-unknown-linux-musl*"
  local zoxide_load=''
  [[ "$DOTFILES_OS" = 'Darwin' ]] && zoxide_use="*-darwin*"
  zplug "ajeetdsouza/zoxide", from:gh-r, as:command, \
    use:"$zoxide_use"

  zplug "BurntSushi/ripgrep", from:gh-r, as:command, rename-to:rg

  local delta_use="*-x86_64-unknown-linux-musl*"
  [[ "$DOTFILES_OS" = 'Darwin' ]] && delta_use="*-darwin*"
  zplug "dandavison/delta", from:gh-r, as:command, rename-to:delta, \
    use:"$delta_use", \
    hook-load:"export GIT_PAGER='delta --dark'"

  zplug "davidosomething/git-relevant", as:command
  zplug "davidosomething/git-take", as:command

  zplug "junegunn/fzf-bin", from:gh-r, as:command, file:fzf, \
    if:"! __dko_has fzf"

  # zplug "mvdan/sh", from:gh-r, as:command, \
  #   hook-build:"mv shfmt* shfmt && chmod +x shfmt"

  zplug "paulirish/git-recent", as:command

  local bat_load="export MANPAGER=\"sh -c 'col -bx | bat --language man --paging always --style=grid'\""
  zplug "sharkdp/bat", from:gh-r, as:command, rename-to:bat, \
    use:"*unknown-linux-musl.tar.gz", \
    hook-load:"$bat_load"

  zplug "sharkdp/fd", from:gh-r, as:command, rename-to:fd

  zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq

  zplug "tj/git-extras", use:"bin/*", as:command

  zplug "zsh-users/zsh-completions"

  #zplug "zsh-users/zsh-syntax-highlighting", defer:2

  # In-line best history match suggestion
  # don't suggest lines longer than
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
  # as of v4.0 use ZSH/zpty module to async retrieve
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  # Removed forward-char
  export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
  zplug "zsh-users/zsh-autosuggestions", \
    hook-load:'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept'

  ! zplug check && zplug install

  zplug load

  __dko_has zoxide &&
    eval "$(zoxide init --no-aliases zsh)" &&
    alias j=__zoxide_z
}

DKO_SOURCE="${DKO_SOURCE} }"
