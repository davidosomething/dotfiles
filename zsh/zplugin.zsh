# zplugin.zsh

export DKO_SOURCE="${DKO_SOURCE} -> zplugin.zsh {"

zplugin snippet --command 'https://github.com/davidosomething/git-ink/blob/master/git-ink'
zplugin snippet --command 'https://github.com/davidosomething/git-my/blob/master/git-my'
zplugin snippet --command 'https://github.com/davidosomething/git-take/blob/master/git-take'
zplugin snippet --command 'https://github.com/davidosomething/vopen/blob/master/vopen-nofork'
zplugin snippet --command 'https://github.com/davidosomething/vopen/blob/master/vopen'

# my fork of cdbk, ZSH hash based directory bookmarking
zplugin light 'davidosomething/cdbk'

# ----------------------------------------------------------------------------
# Vendor: Commands
# ----------------------------------------------------------------------------

zplugin snippet --command 'https://github.com/paulirish/git-open/blob/master/git-open'
zplugin snippet --command 'https://github.com/paulirish/git-recent/blob/master/git-recent'
zplugin snippet --command 'https://github.com/raylee/tldr/blob/master/tldr'

# replaces up() in shell/functions.sh
zplugin snippet --command 'https://github.com/shannonmoeller/up/blob/master/up.sh'

# fork of rupa/z with better completion (so needs defer)
zplugin snippet --command 'https://github.com/knu/z/blob/master/z.sh'

# ----------------------------------------------------------------------------
# Vendor: ZSH extension
# ----------------------------------------------------------------------------

zplugin snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/colored-man-pages/colored-man-pages.plugin.zsh'

# In-line best history match suggestion
zplugin light 'zsh-users/zsh-autosuggestions'
# zsh-autosuggestions -- clear the suggestion when entering completion select
# menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")

# highlight as you type
#zplugin 'zsh-users/zsh-syntax-highlighting', defer:3
zplugin light 'zdharma/fast-syntax-highlighting'

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zplugin light 'zsh-users/zsh-completions'

# gulp completion (parses file so not 100% accurate)
zplugin light 'akoenig/gulp.plugin.zsh'

zplugin light 'gradle/gradle-completion'

zplugin light 'lukechilds/zsh-better-npm-completion'

[[ $OSTYPE == 'darwin'* ]] && \
  zplugin light 'vasyharan/zsh-brew-services'

zplugin light 'voronkovich/phpcs.plugin.zsh'
