# zplugin.zsh

DKO_SOURCE="${DKO_SOURCE} -> zplugin.zsh {"

zplugin ice wait'0' lucid as"program" pick"git-ink"
zplugin light davidosomething/git-ink

zplugin ice wait'0' lucid as"program" pick"git-my"
zplugin light davidosomething/git-my

zplugin ice wait'0' lucid as"program" pick"git-take"
zplugin light davidosomething/git-take

# my fork of cdbk, ZSH hash based directory bookmarking
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zplugin light 'davidosomething/cdbk'

# ----------------------------------------------------------------------------
# Vendor: Commands
# ----------------------------------------------------------------------------

zplugin ice wait'0' lucid as"program" pick"${ZPFX}/bin/git-*" \
  make"PREFIX=$ZPFX" nocompile
zplugin light tj/git-extras
# completions
zplugin ice wait'0' lucid
zplugin snippet "${ZPLGM[PLUGINS_DIR]}/tj---git-extras/etc/git-extras-completion.zsh"

zplugin ice wait'0' lucid as"program" pick"git-open"
zplugin light paulirish/git-open

zplugin ice wait'0' lucid as"program" pick"git-recent"
zplugin light paulirish/git-recent

# replaces up() in shell/functions.sh
zplugin light 'shannonmoeller/up'

zplugin light 'wfxr/forgit'

# ----------------------------------------------------------------------------
# Vendor: ZSH extension
# ----------------------------------------------------------------------------

zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=48
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1
zplugin ice silent wait'0' atload'_zsh_autosuggest_start'
zplugin light 'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zplugin light 'zsh-users/zsh-completions'

zplugin ice as"completion" wait'[[ -n ${ZLAST_COMMANDS[(r)grad*]} ]]' nocompile
zplugin light 'gradle/gradle-completion'

zplugin ice as"completion"
zplugin light 'lukechilds/zsh-better-npm-completion'

[ "$DOTFILES_OS" = 'Darwin' ] \
  && zplugin light 'vasyharan/zsh-brew-services'

zplugin light 'voronkovich/phpcs.plugin.zsh'


[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] \
  && {
    zplugin ice wait'[[ -n ${ZLAST_COMMANDS[(r)trav*]} ]]'
    zplugin light "${TRAVIS_CONFIG_PATH}"
  }

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

zplugin ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zplugin light 'zdharma/fast-syntax-highlighting'

export DKO_SOURCE="${DKO_SOURCE} }"
