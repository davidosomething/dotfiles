# zplugin.zsh

DKO_SOURCE="${DKO_SOURCE} -> zplugin.zsh {"

zplugin snippet --command 'https://github.com/davidosomething/git-ink/blob/master/git-ink'
zplugin snippet --command 'https://github.com/davidosomething/git-my/blob/master/git-my'
zplugin snippet --command 'https://github.com/davidosomething/git-take/blob/master/git-take'

# my fork of cdbk, ZSH hash based directory bookmarking
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zplugin light 'davidosomething/cdbk'

# ----------------------------------------------------------------------------
# Vendor: Commands
# ----------------------------------------------------------------------------

zplugin snippet --command 'https://github.com/paulirish/git-open/blob/master/git-open'
zplugin snippet --command 'https://github.com/paulirish/git-recent/blob/master/git-recent'
zplugin snippet --command 'https://github.com/raylee/tldr/blob/master/tldr'

# replaces up() in shell/functions.sh
zplugin light 'shannonmoeller/up'

# ----------------------------------------------------------------------------
# Vendor: ZSH extension
# ----------------------------------------------------------------------------

zplugin snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/colored-man-pages/colored-man-pages.plugin.zsh'

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=48
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1
zplugin light 'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")

zplugin light 'zdharma/fast-syntax-highlighting'

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zplugin light 'zsh-users/zsh-completions'

zplugin light 'gradle/gradle-completion'

zplugin light 'lukechilds/zsh-better-npm-completion'

zplugin light 'vasyharan/zsh-brew-services'

zplugin light 'voronkovich/phpcs.plugin.zsh'

[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] \
  && zplugin light "${TRAVIS_CONFIG_PATH}"

# ----------------------------------------------------------------------------
# zplugin management
# ----------------------------------------------------------------------------

# zplugin light zdharma/zui
# zplugin light zdharma/zplugin-crasis

export DKO_SOURCE="${DKO_SOURCE} }"
