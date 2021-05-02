# zsh/zinit.zsh

# Order of execution of related Ice-mods: atinit -> atpull! -> make'!!' -> mv
# -> cp -> make! -> atclone/atpull -> make -> (plugin script loading) -> src
# -> multisrc -> atload.

export DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

function {
  local man_dir="${ZPFX}/share/man/man1"
  # Make man dir in /polaris
  mkdir -pv "$man_dir"

  # ----------------------------------------------------------------------------
  # Git
  # ----------------------------------------------------------------------------

  # Note: the mv for @cli/cli normalizes the macOS structure to be the same as
  # the linux ones (there is also a .backup folder in the archive we want to
  # ignore)
  zinit lucid as'program' for \
    from'gh-r' \
    mv'gh* -> usr' \
    pick"usr/bin/gh" \
    atclone"cp -vf usr/**/*.1 \"${man_dir}\"; ./usr/bin/gh completion --shell zsh > _gh" \
    atpull'%atclone' \
    '@cli/cli' \
    \
    from'gh-r' \
    'zaquestion/lab' \
    \
    'davidosomething/git-ink' \
    'davidosomething/git-my' \
    'davidosomething/git-relevant' \
    'davidosomething/git-take' \
    \
    'paulirish/git-recent' \
    \
    pick"${ZPFX}/bin/git-*" \
    src'etc/git-extras-completion.zsh' \
    make"PREFIX=${ZPFX}" \
    'tj/git-extras' \
    ;

  # ----------------------------------------------------------------------------
  # FZF
  # ----------------------------------------------------------------------------

  zinit lucid for \
    if'! __dko_has fzf' from'gh-r' as'program' 'junegunn/fzf-bin' \
    \
    'torifat/npms' \
    \
    from'gh-r' as'program' \
    'jesseduffield/lazydocker' \
    ;

  # ----------------------------------------------------------------------------
  # Utilities
  # ----------------------------------------------------------------------------

  # my fork of cdbk, ZSH hash based directory bookmarking. No wait!
  export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
  zinit lucid light-mode for 'davidosomething/cdbk'

  export _ZO_DATA="${XDG_DATA_HOME}/zoxide"

  # Customized from instructions at https://github.com/sharkdp/bat#man
  local bat_manpager="export MANPAGER=\"sh -c 'col -bx | bat --language man --paging always --style=grid'\""
  local delta_gitpager="export GIT_PAGER='delta --dark'"

  zinit lucid from'gh-r' as'program' for \
    mv'bat* -> bat' \
    pick'bat/bat' \
    atclone'cp -vf bat/bat.1 "${ZPFX}/share/man/man1"; cp -vf bat/autocomplete/bat.zsh "bat/autocomplete/_bat"' \
    atpull'%atclone' \
    atload"$bat_manpager" \
    '@sharkdp/bat' \
    \
    mv'delta* -> delta' \
    pick'delta/delta' \
    atload"$delta_gitpager" \
    'dandavison/delta' \
    \
    mv'fd* -> fd' pick'fd/fd' \
    atclone'cp -vf fd/fd.1 "${ZPFX}/share/man/man1"' \
    atpull'%atclone' \
    '@sharkdp/fd' \
    \
    mv'jq* -> jq'             'stedolan/jq' \
    mv'nvim-ctrl* -> nvctl'   'chmln/nvim-ctrl'   \
    mv'shfmt* -> shfmt'       '@mvdan/sh'         \
    \
    mv'zoxide* -> zoxide' \
    atclone'cp -vf zoxide/man/*.1 "${ZPFX}/share/man/man1"; chmod +x zoxide' \
    atpull'%atclone' \
    atload'eval "$(zoxide init --no-aliases zsh)" && alias j=__zoxide_z' \
    'ajeetdsouza/zoxide' \
    \
    mv'ripgrep* -> rg' pick'rg/rg' \
    atclone'cp -vf rg/doc/rg.1 "${ZPFX}/share/man/man1"' \
    atpull'%atclone' \
    'BurntSushi/ripgrep' \
    ;

  zinit snippet 'OMZP::cp'
  zinit snippet 'OMZP::extract'

  # ----------------------------------------------------------------------------
  # Completions
  # ----------------------------------------------------------------------------

  zinit as'completion' is-snippet for \
    'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
    'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \
    ;

  # In-line best history match suggestion
  # don't suggest lines longer than
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
  # as of v4.0 use ZSH/zpty module to async retrieve
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  # Removed forward-char
  export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  zinit lucid wait for \
    atload'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept' \
    'zsh-users/zsh-autosuggestions' \
    \
    blockf atpull'zinit creinstall -q .' \
    'zsh-users/zsh-completions' \
    ;

  # ----------------------------------------------------------------------------
  # Syntax last, and compinit before it
  # ----------------------------------------------------------------------------

  # don't add wait, messes with zsh-autosuggest
  zinit lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" for \
    'zdharma/fast-syntax-highlighting'
}

DKO_SOURCE="${DKO_SOURCE} }"
