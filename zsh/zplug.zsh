# zplug.zsh
#
# Loaded by zplug when path assigned to ZPLUG_LOADFILE
#

# --------------------------------------------------------------------------
# Mine
# --------------------------------------------------------------------------

zplug "${ZDOTDIR}", \
  from:local, \
  use:"{keybindings,prompt,title}.zsh"

zplug "davidosomething/git-ink",  as:command
zplug "davidosomething/git-my",   as:command
zplug "davidosomething/git-open", as:command

# my fork of cdbk, zsh hash based directory bookmarking
zplug "davidosomething/cdbk"

# --------------------------------------------------------------------------
# Vendor
# --------------------------------------------------------------------------

zplug "robbyrussell/oh-my-zsh", use:"plugins/colored-man-pages/*.zsh"

# In-line best history match suggestion
zplug "tarruda/zsh-autosuggestions"

# Various program completions
# This adds to fpath (so before compinit)
zplug "zsh-users/zsh-completions"

# --------------------------------------------------------------------------
# LAST, these call "compdef" so must be run after compinit, enforced by nice
# --------------------------------------------------------------------------

# fork of rupa/z with better completion (so needs nice)
zplug "knu/z", nice:10, use:'z.sh'

# --------------------------------------------------------------------------
# Completions that require compdef (so nice 10)
# --------------------------------------------------------------------------

# gulp completion (parses file so not 100% accurate)
zplug "akoenig/gulp.plugin.zsh", nice:10

# 2016-04-27 nvm assumes ~/.nvm exists, so probably not working
zplug "robbyrussell/oh-my-zsh", nice:10, \
  use:"plugins/{golang/*.zsh,nvm/_nvm}"

# homebrew
# note regular brew completion is broken:
# @see <https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Tips-N'-Tricks.md#zsh>
# @see <https://github.com/Homebrew/homebrew/issues/49066>
#
# fix by symlinking
#     ln -s $(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh $(brew --prefix)/share/zsh/site-functions/_brew
#
# These addons need to be nice, otherwise won't override _brew

zplug "vasyharan/zsh-brew-services",  \
  if:"[[ $OSTYPE == *darwin* ]]",     \
  nice:10

zplug "robbyrussell/oh-my-zsh",       \
  if:"[[ $OSTYPE == *darwin* ]]",     \
  nice:10,                            \
  use:"plugins/brew-cask/*.zsh"

# highlight as you type
zplug "zsh-users/zsh-syntax-highlighting", nice:19

