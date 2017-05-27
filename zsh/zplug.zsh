# zplug.zsh
#
# Loaded by zplug when path assigned to ZPLUG_LOADFILE
#
# Use repo format for oh-my-zsh plugins so no random crap is sourced
#
# Make sure fpaths are defined before or within zplug -- it calls compinit
# again in between loading plugins and defer plugins.
#

# ----------------------------------------------------------------------------
# Mine
# ----------------------------------------------------------------------------

zplug "davidosomething/git-ink",  as:command
zplug "davidosomething/git-my",   as:command
zplug "davidosomething/git-take", as:command
zplug "paulirish/git-open",       as:command
zplug "paulirish/git-recent",     as:command

# my fork of cdbk, zsh hash based directory bookmarking
zplug "davidosomething/cdbk"

# zplug "~/projects/davidosomething/vopen", \
  # from:local, \
zplug "davidosomething/vopen",  \
  use:"{vopen,vopen-nofork}",   \
  as:command

# ----------------------------------------------------------------------------
# Vendor
# ----------------------------------------------------------------------------

zplug 'raylee/tldr', as:command

# replaces up() in shell/functions.sh
zplug 'shannonmoeller/up', use:"up.sh"

zplug "plugins/colored-man-pages", from:oh-my-zsh

# In-line best history match suggestion
zplug "zsh-users/zsh-autosuggestions"

# Various program completions; includes go, nvm
# This adds to fpath (so before compinit)
zplug "zsh-users/zsh-completions"

# ----------------------------------------------------------------------------
# LAST, these call "compdef" so must be run after compinit
# ----------------------------------------------------------------------------

# brew completions, re-source these since
# - they may have .bash extension like tig completion
# - rely on bashcompinit like aws
[[ $OSTYPE == "darwin"* ]] && \
  zplug "/usr/local/share/zsh/site-functions", \
    from:local,   \
    use:"*",      \
    defer:2

# Add my local completions
zplug "${ZDOTDIR}/fpath", \
  from:local,   \
  use:"*",      \
  defer:2

# fork of rupa/z with better completion (so needs defer)
zplug "knu/z",  \
  use:"z.sh",   \
  defer:2,      \
  hook-build:'cp z.1 "${HOME}/.local/man/man1/"'

# gulp completion (parses file so not 100% accurate)
zplug "akoenig/gulp.plugin.zsh", defer:2

zplug "lukechilds/zsh-better-npm-completion", defer:2

[[ $OSTYPE == "darwin"* ]] && \
  zplug "vasyharan/zsh-brew-services", defer:2

zplug "voronkovich/phpcs.plugin.zsh", defer:2

# # completions I have locally
# zplug "${ZDOTDIR}",     \
#   from:local,           \
#   use:"completions/_*", \
#   defer:18

# ==============================================================================
# absolute last
# ==============================================================================

# highlight as you type
#zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zdharma/fast-syntax-highlighting", defer:3

# ==============================================================================
# Add zplug's man to MANPATH
# ==============================================================================

MANPATH="${ZPLUG_ROOT}/doc/man:${MANPATH}"
export MANPATH
