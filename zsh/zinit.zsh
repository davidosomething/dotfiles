# zsh/zinit.zsh

DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

zplugin lucid wait as'program' pick'git-ink'
zplugin light davidosomething/git-ink

zplugin lucid wait as'program' pick'git-my'
zplugin light davidosomething/git-my

zplugin lucid wait as'program' pick'git-take'
zplugin light davidosomething/git-take

# my fork of cdbk, ZSH hash based directory bookmarking. No wait.
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zplugin lucid
zplugin light 'davidosomething/cdbk'

# ----------------------------------------------------------------------------
# Vendor: Commands
# ----------------------------------------------------------------------------

zplugin lucid as'program' \
  pick"${ZPFX}/bin/git-*" \
  src"etc/git-extras-completion.zsh" \
  make"PREFIX=$ZPFX"
zplugin light tj/git-extras

if ! __dko_has fzf; then
  # Binary release in archive, from GitHub-releases page.
  # After automatic unpacking it provides program "fzf".
  zinit ice from"gh-r" as"program"
  zinit load junegunn/fzf-bin
fi

# `` compl for git commands
zplugin lucid wait
zplugin light 'hschne/fzf-git'

zplugin lucid wait as'program' pick'git-open'
zplugin light paulirish/git-open

zplugin lucid wait as'program' pick'git-recent'
zplugin light paulirish/git-recent

if __dko_has lua; then
  export _ZL_CMD='j'
  export _ZL_DATA="${XDG_DATA_HOME}/zlua"
  export _ZL_HYPHEN=1
  export _ZL_NO_ALIASES=1
  zplugin lucid nocompletions
  #zplugin light 'davidosomething/z.lua'
  zplugin light 'skywind3000/z.lua'

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
  zplugin lucid nocompletions
  zplugin light 'shannonmoeller/up'
fi

# gi is my git-ink alias, and i don't need a .gitignore generator
export forgit_ignore='fgi'
zplugin lucid wait
zplugin light 'wfxr/forgit'

zplugin lucid wait lucid as'program' pick'bin/git-dsf'
zplugin light zdharma/zsh-diff-so-fancy

# ----------------------------------------------------------------------------
# Vendor: ZSH extension
# ----------------------------------------------------------------------------

zplugin lucid wait'[[ -n ${ZLAST_COMMANDS[(r)man*]} ]]'
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=48
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1
zplugin lucid wait'1' atload'_zsh_autosuggest_start'
zplugin load 'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=('expand-or-complete')

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zplugin lucid wait blockf atpull'zplugin creinstall -q .'
zplugin load 'zsh-users/zsh-completions'

[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] \
  && {
    zplugin lucid wait
    zplugin light "$TRAVIS_CONFIG_PATH"
  }

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

zplugin lucid wait'1' atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zplugin load 'zdharma/fast-syntax-highlighting'

export DKO_SOURCE="${DKO_SOURCE} }"
