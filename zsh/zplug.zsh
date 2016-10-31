# zplug.zsh
#
# Loaded by zplug when path assigned to ZPLUG_LOADFILE
#
# Use repo format for oh-my-zsh plugins so no random crap is sourced
#
# Make sure fpaths are defined before or within zplug -- it calls compinit
# again in between loading plugins and nice plugins.
#

# ----------------------------------------------------------------------------
# Mine
# ----------------------------------------------------------------------------

zplug "${ZDOTDIR}", \
  from:local, \
  use:"{keybindings,prompt,title}.zsh"

zplug "davidosomething/git-ink",  as:command
zplug "davidosomething/git-my",   as:command
zplug "davidosomething/git-take", as:command
zplug "paulirish/git-open",       as:command

# my fork of cdbk, zsh hash based directory bookmarking
zplug "davidosomething/cdbk"

# zplug "~/projects/vopen", \
#   from:local, \
zplug "davidosomething/vopen",     \
  use:"{vopen,vopen-nofork}", \
  as:command

# ----------------------------------------------------------------------------
# Vendor
# ----------------------------------------------------------------------------

zplug "plugins/colored-man-pages", from:oh-my-zsh

# In-line best history match suggestion
zplug "tarruda/zsh-autosuggestions"

# Various program completions
# This adds to fpath (so before compinit)
zplug "zsh-users/zsh-completions"

# ----------------------------------------------------------------------------
# LAST, these call "compdef" so must be run after compinit, enforced by nice
# ----------------------------------------------------------------------------

# fork of rupa/z with better completion (so needs nice)
zplug "knu/z",  \
  use:"z.sh",   \
  nice:10

# ----------------------------------------------------------------------------
# Completions that require compdef (so nice 10)
# ----------------------------------------------------------------------------

# gulp completion (parses file so not 100% accurate)
zplug "akoenig/gulp.plugin.zsh", nice:10

zplug "plugins/golang", \
  from:oh-my-zsh,       \
  nice:10

zplug "lukechilds/zsh-better-npm-completion", \
  nice:11

# 2016-04-27 nvm assumes ~/.nvm exists, so probably not working
# My (unmerged) PR here:
#   https://github.com/robbyrussell/oh-my-zsh/pull/5047/files
# zplug "robbyrussell/oh-my-zsh", \
#   use:"plugins/nvm/_nvm",       \
#   nice:10

# Moved if block outside since `zplug check` doesn't consider it
if [[ $OSTYPE == "darwin"* ]]; then
  zplug "vasyharan/zsh-brew-services",  \
    nice:10
fi

# # completions I have locally
# zplug "${ZDOTDIR}",     \
#   from:local,           \
#   use:"completions/_*", \
#   nice:18

# highlight as you type
zplug "zsh-users/zsh-syntax-highlighting", nice:19
