# zplugin.zsh

DKO_SOURCE="${DKO_SOURCE} -> zplugin.zsh {"

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

# `` compl for git commands
zplugin lucid wait
zplugin light 'hschne/fzf-git'

zplugin lucid wait as'program' pick'git-open'
zplugin light paulirish/git-open

zplugin lucid wait as'program' pick'git-recent'
zplugin light paulirish/git-recent

# replaces up() in shell/functions.sh. No wait.
zplugin lucid nocompletions
zplugin light 'shannonmoeller/up'

zplugin lucid nocompletions
zplugin light 'skywind3000/z.lua'

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
zplugin lucid wait atload'_zsh_autosuggest_start'
zplugin load 'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=('expand-or-complete')

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zplugin blockf lucid wait
zplugin load 'zsh-users/zsh-completions'

zplugin lucid wait
zplugin light 'voronkovich/phpcs.plugin.zsh'


[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] \
  && {
    zplugin lucid wait
    zplugin light "$TRAVIS_CONFIG_PATH"
  }

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

zplugin lucid wait'1' atinit'zpcompinit; zpcdreplay'
zplugin load 'zdharma/fast-syntax-highlighting'

export DKO_SOURCE="${DKO_SOURCE} }"
