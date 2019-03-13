# zplugin.zsh

DKO_SOURCE="${DKO_SOURCE} -> zplugin.zsh {"

zplugin ice lucid wait'0' as'program' pick'git-ink'
zplugin load davidosomething/git-ink

zplugin ice lucid wait'0' as'program' pick'git-my'
zplugin load davidosomething/git-my

zplugin ice lucid wait'0' as'program' pick'git-take'
zplugin load davidosomething/git-take

# my fork of cdbk, ZSH hash based directory bookmarking
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zplugin ice lucid wait'0' 
zplugin load 'davidosomething/cdbk'

# ----------------------------------------------------------------------------
# Vendor: Commands
# ----------------------------------------------------------------------------

zplugin ice lucid wait'0' as'program' pick"${ZPFX}/bin/git-*" \
  make"PREFIX=$ZPFX" nocompile
zplugin load tj/git-extras
# completions
zplugin ice lucid wait'0'
zplugin snippet "${ZPLGM[PLUGINS_DIR]}/tj---git-extras/etc/git-extras-completion.zsh"

zplugin ice lucid wait'0' as'program' pick'git-open'
zplugin load paulirish/git-open

zplugin ice lucid wait'0' as'program' pick'git-recent'
zplugin load paulirish/git-recent

# replaces up() in shell/functions.sh
zplugin ice lucid wait'0'
zplugin load 'shannonmoeller/up'
zplugin cdclear -q # forget completions for up

export forgit_ignore='fgi'
zplugin ice lucid wait'0'
zplugin load 'wfxr/forgit'

zplugin ice lucid wait'0' lucid as'program' pick'bin/git-dsf'
zplugin light zdharma/zsh-diff-so-fancy

# ----------------------------------------------------------------------------
# Vendor: ZSH extension
# ----------------------------------------------------------------------------

zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)man*]} ]]'
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=48
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1
zplugin ice lucid wait'0' atload'_zsh_autosuggest_start'
zplugin load 'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=('expand-or-complete')

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zplugin ice lucid wait'0'
zplugin load 'zsh-users/zsh-completions'

zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)grad*]} ]]' as'completion' nocompile
zplugin load 'gradle/gradle-completion'

zplugin ice lucid wait'0'
zplugin load 'lukechilds/zsh-better-npm-completion'

zplugin ice lucid wait'0'
zplugin load 'voronkovich/phpcs.plugin.zsh'


[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] \
  && {
    zplugin ice lucid wait'0'
    zplugin load "${TRAVIS_CONFIG_PATH}"
  }

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

zplugin ice lucid wait'0' atinit'zpcompinit; zpcdreplay'
zplugin load 'zdharma/fast-syntax-highlighting'

export DKO_SOURCE="${DKO_SOURCE} }"
