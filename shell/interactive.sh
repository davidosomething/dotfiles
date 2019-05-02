# shell/interactive.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.sh[interactive] {"
if [ -f "${HOME}/.dotfiles/local/dotfiles.lock" ]; then
  "${DOTFILES}/shell/dko-wait-for-dotfiles-lock"
fi

# need this here in case not starting a login shell
. "${DOTFILES}/lib/helpers.sh"

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

. "${DOTFILES}/shell/go.sh"
. "${DOTFILES}/shell/java.sh"
. "${DOTFILES}/shell/node.sh"
. "${DOTFILES}/shell/php.sh"
. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/ruby.sh"

# ============================================================================
# interactive aliases and functions
# ============================================================================

. "${DOTFILES}/shell/functions.sh" # shell functions
. "${DOTFILES}/shell/aliases.sh"   # generic aliases

if [ "$DOTFILES_OS" = 'Linux' ]; then
  . "${DOTFILES}/shell/aliases-linux.sh"
  case "$DOTFILES_DISTRO" in
  "archlinux" | "debian" | "fedora")
    . "${DOTFILES}/shell/aliases-${DOTFILES_DISTRO}.sh"
    ;;
  esac
else
  . "${DOTFILES}/shell/aliases-darwin.sh"
fi

# ============================================================================
# FZF settings
# ============================================================================

fzfopts="--height=20 --inline-info --min-height=4"

# ** is globbing completion in ZSH, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"

# Use fastest grepper available
if __dko_prefer "rg"; then
  grepper="rg --glob ''"
  grepargs="--files --ignore-file \"${DOTFILES}/ag/dot.ignore\""
elif __dko_has "ag"; then
  grepper='ag'
  grepargs='-g ""'
elif __dko_has "fd"; then
  grepper='fd'
  grepargs='--type f'
else
  # using git paths only for FZF
  grepper='
    (git ls-tree -r --name-only HEAD ||
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
        sed s/^..//) 2> /dev/null'
  grepargs=''
fi
export FZF_DEFAULT_COMMAND="${grepper} ${grepargs}"

# This is used by fzf#vim#with_preview's preview.sh
export FZF_PREVIEW_COMMAND="
  bat --color=always --decorations=never --line-range :100 {}
  "

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="
  ${fzfopts}
  --tiebreak=index
  --preview='[[ ! \$(file --mime {}) =~ binary ]] &&
    ${FZF_PREVIEW_COMMAND}
  "

export FZF_ALT_C_OPTS="
  ${fzfopts}
  --tiebreak=index
  --preview='tree -axi -L 2 --filelimit 100 --noreport {}'
  "

# This needs to happen before sourcing the default fzf bind scripts
if __dko_has "fd"; then
  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
