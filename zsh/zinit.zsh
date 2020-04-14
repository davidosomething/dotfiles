# zsh/zinit.zsh

export DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

# ----------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------

__dko_has docker && zinit for \
  silent as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  lucid from'gh-r' as'program' 'jesseduffield/lazydocker'

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------

zinit lucid as'program' pick for \
  'davidosomething/git-ink' \
  'davidosomething/git-my' \
  'davidosomething/git-take' \
  'paulirish/git-open' \
  'paulirish/git-recent'

zinit lucid as'program' \
  pick"${ZPFX}/bin/git-*" \
  src'etc/git-extras-completion.zsh' \
  make"PREFIX=${ZPFX}" \
  for 'tj/git-extras'

# ----------------------------------------------------------------------------
# FZF + Git
# ----------------------------------------------------------------------------

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
! __dko_has fzf && zinit lucid from'gh-r' as'program' for \
  'junegunn/fzf-bin'

# gi is my git-ink alias, and i don't need a .gitignore generator
export forgit_ignore='fgi'
# fzf-git -- `` compl for git commands
zinit lucid for \
  'wfxr/forgit' \
  'hschne/fzf-git'

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

# my fork of cdbk, ZSH hash based directory bookmarking. No wait!
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zinit lucid light-mode for 'davidosomething/cdbk'

# no wait, want programs available so i can type before prompt ready
zinit lucid from'gh-r' as'program' for \
  pick'bat/bat'             mv'bat* -> bat'             '@sharkdp/bat' \
  pick'delta*/delta'                                    'dandavison/delta' \
  pick'fd/fd'               mv'fd* -> fd'               '@sharkdp/fd' \
  pick'mvdan/sh'            mv'shfmt* -> shfmt'         '@mvdan/sh' \
  pick'ajeetdsouza/zoxide'  mv'zoxide* -> zoxide' \
  atload'eval "$(zoxide init zsh)"'                     'ajeetdsouza/zoxide' \
                            mv'nvim-ctrl* -> nvctl'     'chmln/nvim-ctrl'

export GIT_PAGER="delta --dark"
export _ZO_DATA="${XDG_DATA_HOME}/zoxide"
alias j=z
zinit lucid nocompletions light-mode for '@shannonmoeller/up'

# ----------------------------------------------------------------------------
# ZSH extensions
# ----------------------------------------------------------------------------

zinit lucid trigger-load'!man' for is-snippet \
  'OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh'

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
# as of v4.0 use ZSH/zpty module to async retrieve
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# Removed forward-char
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ! will track the loading since using zinit load
zinit lucid wait \
  atload'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept' for \
  'zsh-users/zsh-autosuggestions'

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zinit lucid wait blockf atpull'zinit creinstall -q .' for \
  'zsh-users/zsh-completions'

[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] &&
  zinit lucid wait for "$TRAVIS_CONFIG_PATH"

__dko_has keybase && zinit silent as'completion' is-snippet for \
  'https://github.com/zeroryuki/zsh-keybase/blob/master/_keybase'

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

# don't add wait, messes with zsh-autosuggest
zinit lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" for \
  'zdharma/fast-syntax-highlighting'

DKO_SOURCE="${DKO_SOURCE} }"
