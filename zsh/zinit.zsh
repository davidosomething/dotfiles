# zsh/zinit.zsh

export DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

# ----------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------

__dko_has docker && {
  zinit for silent as'completion' is-snippet \
    'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker'
  zinit for light-mode lucid wait from'gh-r' as'program' \
    'jesseduffield/lazydocker'
}

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------

zinit for light-mode lucid wait as'program' pick davidosomething/git-ink
zinit for light-mode lucid wait as'program' pick davidosomething/git-my
zinit for light-mode lucid wait as'program' pick davidosomething/git-take
zinit for light-mode lucid wait as'program' pick paulirish/git-open
zinit for light-mode lucid wait as'program' pick paulirish/git-recent

zinit for lucid wait as'program' \
  pick"${ZPFX}/bin/git-*" \
  src'etc/git-extras-completion.zsh' \
  make"PREFIX=${ZPFX}" \
  light-mode 'tj/git-extras'

zinit for lucid wait as'program' pick'bin/git-dsf' \
  light-mode 'zdharma/zsh-diff-so-fancy'

# ----------------------------------------------------------------------------
# FZF + Git
# ----------------------------------------------------------------------------

! __dko_has fzf && {
  # Binary release in archive, from GitHub-releases page.
  # After automatic unpacking it provides program "fzf".
  zinit for lucid wait from'gh-r' as'program' light-mode 'junegunn/fzf-bin'
}

# gi is my git-ink alias, and i don't need a .gitignore generator
export forgit_ignore='fgi'
zinit for lucid wait light-mode 'wfxr/forgit'

# `` compl for git commands
zinit for lucid wait light-mode 'hschne/fzf-git'

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

# my fork of cdbk, ZSH hash based directory bookmarking. No wait!
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zinit for lucid light-mode 'davidosomething/cdbk'

zinit for lucid wait from'gh-r' as'program' \
  mv'bat* -> bat' pick'bat/bat' \
  light-mode '@sharkdp/bat'
zinit for lucid wait from'gh-r' as'program' \
  pick'delta*/delta' \
  atload'GIT_PAGER="delta --dark"' \
  light-mode '@dandavison/delta'
zinit for lucid wait from'gh-r' as'program' \
  mv'fd* -> fd' pick'fd/fd' \
  light-mode '@sharkdp/fd'
zinit for lucid wait from'gh-r' as'program' \
  mv'shfmt* -> shfmt' pick'mvdan/sh' \
  light-mode '@mvdan/sh'

__dko_has cargo && {
  export _ZO_DATA="${XDG_DATA_HOME}/zoxide"
  zinit for lucid atclone'cargo install zoxide' atpull'%atclone' \
    light-mode 'ajeetdsouza/zoxide'
  alias j=z
}

__dko_has z || {
  export _ZL_CMD='j'
  export _ZL_DATA="${XDG_DATA_HOME}/zlua"
  export _ZL_HYPHEN=1
  export _ZL_NO_ALIASES=1
  zinit for lucid nocompletions light-mode 'skywind3000/z.lua'

  # redefine up to work like shannonmoeller/up
  up() {
    number='^[0-9]+$'
    if [[ -z "$1" ]] || [[ "$1" =~ "$number" ]] ; then
      eval "${_ZL_CMD} -b ..${1}"
    else
      eval "${_ZL_CMD} $@"
    fi
  }
}

__dko_has z || {
  export ZSHZ_CMD=j
  export ZSHZ_DATA="${XDG_DATA_HOME}/zshz"
  zinit load 'agkozak/zsh-z'
}

__dko_has up || {
  zinit for lucid nocompletions light-mode '@shannonmoeller/up'
}

# ----------------------------------------------------------------------------
# ZSH extensions
# ----------------------------------------------------------------------------

zinit for lucid trigger-load'!man' is-snippet \
  'OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh'

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1
# Removed forward-char
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
  vi-end-of-line
  vi-add-eol
)

# ! will track the loading since using zinit load
zinit for lucid wait \
  atload'_zsh_autosuggest_start && bindkey "^k" autosuggest-accept' \
  'zsh-users/zsh-autosuggestions'
# clear the suggestion when entering completion select menu

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zinit for lucid wait blockf atpull'zinit creinstall -q .' \
  'zsh-users/zsh-completions'

[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] && {
  zinit for lucid wait light-mode "$TRAVIS_CONFIG_PATH"
}

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

# clear the suggestion when entering completion select menu
zinit for lucid wait atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  'zdharma/fast-syntax-highlighting'

DKO_SOURCE="${DKO_SOURCE} }"
