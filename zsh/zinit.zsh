# zsh/zinit.zsh

# Order of execution of related Ice-mods: atinit -> atpull! -> make'!!' -> mv
# -> cp -> make! -> atclone/atpull -> make -> (plugin script loading) -> src
# -> multisrc -> atload.

export DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

function {
  local man_dir="${ZPFX}/share/man/man1"
  # Make man dir in /polaris
  mkdir -p "$man_dir"

  zinit lucid as"program" from"gh-r" \
    atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' \
    mv"direnv* -> direnv" \
    pick"direnv" \
    src="zhook.zsh" \
    for direnv/direnv

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
    atclone"
      cp -vf usr/**/*.1 \"${man_dir}\";
      ./usr/bin/gh completion --shell zsh > _gh
      " \
    atpull'%atclone' \
    '@cli/cli' \
    \
    'davidosomething/git-relevant' \
    'davidosomething/git-take' \
    \
    pick"${ZPFX}/bin/git-*" \
    src'etc/git-extras-completion.zsh' \
    make"PREFIX=${ZPFX}" \
    'tj/git-extras' \
    ;

  # ----------------------------------------------------------------------------
  # Utilities
  # ----------------------------------------------------------------------------

  # my fork of cdbk, ZSH hash based directory bookmarking. No wait!
  export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
  zinit lucid light-mode for 'davidosomething/cdbk'

  export _ZO_DATA="${XDG_DATA_HOME}/zoxide"

  # Customized from instructions at https://github.com/sharkdp/bat#man
  local bat_manpager="export MANPAGER=\"sh -c 'col -bx | bat --language man --paging always --style=grid'\"; export MANROFFOPT="-c""

  zinit lucid from'gh-r' as'program' for \
    mv'bat* -> bat' \
    pick'bat/bat' \
    atclone"
      cp -vf bat/bat.1 \"${man_dir}\";
      cp -vf bat/autocomplete/bat.zsh \"bat/autocomplete/_bat\"
      " \
    atpull'%atclone' \
    atload"$bat_manpager" \
    '@sharkdp/bat' \
    \
    atclone'delta/delta --generate-completion zsh > delta/_delta' \
    atpull'%atclone' \
    mv'delta* -> delta' \
    pick'delta/delta' \
    'dandavison/delta' \
    \
    mv'fd* -> fd' pick'fd/fd' \
    atclone"cp -vf fd/fd.1 \"${man_dir}\"" \
    atpull'%atclone' \
    '@sharkdp/fd' \
    \
    atload'source <(fzf --zsh)' \
    'junegunn/fzf' \
    \
    mv'jq* -> jq' \
    'jqlang/jq' \
    \
    mv'ripgrep* -> rg' pick'rg/rg' \
    atclone"cp -vf rg/doc/rg.1 \"${man_dir}\"" \
    atpull'%atclone' \
    'BurntSushi/ripgrep' \
    \
    atload'eval "$(zoxide init --cmd j zsh)"' \
    pick'zoxide/zoxide' \
    'ajeetdsouza/zoxide' \
    ;

  zinit snippet 'OMZP::cp'
  zinit snippet 'OMZP::extract'

  if [[ -d "$ASDF_DATA_DIR" ]]; then
    # loads asdf.sh
    zinit snippet 'OMZP::asdf'
  else
    local mise_bpick=""
    [[ $DOTFILES_OS == "Linux" ]] && mise_bpick="*-linux-x64.tar.gz"
    [[ $DOTFILES_OS == "Darwin" ]] && {
      mise_bpick="*-macos-x64.tar.gz"
      [[ $DOTFILES_DISTRO == "arm64" ]] && mise_bpick="*-macos-arm64.tar.gz"
    }
    zinit ice lucid from'gh-r' as'program' bpick"$mise_bpick" \
      pick'mise/bin/mise' \
      atclone"
          cp -vf mise/man/man1/mise.1 $ZINIT[MAN_DIR]/man1;
          ./mise/bin/mise completion zsh > _mise
          " \
      atpull'%atclone' \
      atload'eval "$(mise activate zsh)"'
    zinit light 'jdx/mise'
  fi

  # ----------------------------------------------------------------------------
  # Completions
  # ----------------------------------------------------------------------------

  zinit as'completion' is-snippet for 'OMZP::docker-compose/_docker-compose'

  # In-line best history match suggestion
  # don't suggest lines longer than
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
  # as of v4.0 use ZSH/zpty module to async retrieve
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  # Removed forward-char
  export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)
  export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-word)
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  #export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  zinit lucid wait for \
    'lukechilds/zsh-better-npm-completion' \
    \
    atload'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept' \
    'zsh-users/zsh-autosuggestions' \
    \
    blockf atpull'zinit creinstall -q .' \
    'zsh-users/zsh-completions' \
    ;

  # ----------------------------------------------------------------------------
  # Syntax last
  # autoload and run compinit
  # ----------------------------------------------------------------------------

  # don't add wait, messes with zsh-autosuggest
  zinit lucid atload"zicompinit; zicdreplay" for \
    'zdharma/fast-syntax-highlighting'

  # completion that wants compinit
  zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
  zinit light g-plane/pnpm-shell-completion

}

DKO_SOURCE="${DKO_SOURCE} }"
