# zsh/zinit.zsh

DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

# my fork of cdbk, ZSH hash based directory bookmarking. No wait.
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zinit lucid
zinit light 'davidosomething/cdbk'

# ----------------------------------------------------------------------------
# Finders
# ----------------------------------------------------------------------------

if ! __dko_has fzf; then
  # Binary release in archive, from GitHub-releases page.
  # After automatic unpacking it provides program "fzf".
  zinit lucid from'gh-r' as'program'
  zinit light junegunn/fzf-bin
fi

zinit lucid wait from'gh-r' as'program' mv'fd* -> fd' pick'fd/fd'
zinit light sharkdp/fd

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------

zinit lucid wait as'program' pick'git-ink'
zinit light davidosomething/git-ink

zinit lucid wait as'program' pick'git-my'
zinit light davidosomething/git-my

zinit lucid wait as'program' pick'git-take'
zinit light davidosomething/git-take

zinit lucid as'program' \
  pick"${ZPFX}/bin/git-*" \
  src'etc/git-extras-completion.zsh' \
  make"PREFIX=${ZPFX}"
zinit light tj/git-extras

zinit lucid wait as'program' pick'git-open'
zinit light paulirish/git-open

zinit lucid wait as'program' pick'git-recent'
zinit light paulirish/git-recent

# gi is my git-ink alias, and i don't need a .gitignore generator
export forgit_ignore='fgi'
zinit lucid wait
zinit light 'wfxr/forgit'

zinit lucid wait as'program' pick'bin/git-dsf'
zinit light zdharma/zsh-diff-so-fancy

# `` compl for git commands
zinit lucid wait
zinit light 'hschne/fzf-git'

# ----------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------

if __dko_has docker; then
  zinit as'completion'
  zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

  zinit lucid wait from'gh-r' as'program'
  zinit light jesseduffield/lazydocker
fi

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

zinit lucid wait from'gh-r' as'program' mv'bat* -> bat' pick'bat/bat'
zinit light sharkdp/bat

zinit lucid wait from'gh-r' as'program' mv'shfmt* -> shfmt' pick'mvdan/sh'
zinit light mvdan/sh

if __dko_has lua; then
  export _ZL_CMD='j'
  export _ZL_DATA="${XDG_DATA_HOME}/zlua"
  export _ZL_HYPHEN=1
  export _ZL_NO_ALIASES=1
  zinit lucid nocompletions
  #zinit light 'davidosomething/z.lua'
  zinit light 'skywind3000/z.lua'

  # redefine up to work like shannonmoeller/up
  up() {
    number='^[0-9]+$'
    if [[ -z "$1" ]] || [[ "$1" =~ "$number" ]] ; then
      eval "${_ZL_CMD} -b ..${1}"
    else
      eval "${_ZL_CMD} $@"
    fi
  }
else
  zinit lucid nocompletions
  zinit light 'shannonmoeller/up'
fi

# ----------------------------------------------------------------------------
# ZSH extensions
# ----------------------------------------------------------------------------

zinit lucid wait'[[ -n ${ZLAST_COMMANDS[(r)man*]} ]]'
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=48
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1
zinit lucid wait'1' atload'_zsh_autosuggest_start'
zinit load 'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=('expand-or-complete')

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zinit lucid wait blockf atpull'zinit creinstall -q .'
zinit load 'zsh-users/zsh-completions'

[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] \
  && {
    zinit lucid wait
    zinit light "$TRAVIS_CONFIG_PATH"
  }

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

zinit lucid wait'1' atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit load 'zdharma/fast-syntax-highlighting'

export DKO_SOURCE="${DKO_SOURCE} }"
