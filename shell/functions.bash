# shell/functions.bash
#
# Sourced in bash and ZSH by loader

export DKO_SOURCE="${DKO_SOURCE} -> shell/functions.bash"

# ============================================================================
# Scripting
# ============================================================================

current_shell() {
  ps -p $$ | awk 'NR==2 { print $4 }'
}

# ============================================================================
# Directory
# ============================================================================

# flatten a dir
flatten() {
  if [[ -n "$1" ]]; then
    read -r "reply?Flatten folder: are you sure? [y] "
  else
    local _reply=y
  fi

  [[ "$_reply" = "y" ]] && mv ./*/* .
}

# delete empty subdirs
prune() {
  if [[ -n "$1" ]]; then
    read -r "reply?Prune empty directories: are you sure? [y] "
  else
    local _reply=y
  fi

  [[ "$_reply" = y ]] && find . -type d -empty -delete
}

# Go to git root
cdr() {
  git rev-parse || return 1
  cd -- "$(git rev-parse --show-cdup)" || return 1
}

# up 2 to cd ../..
up() {
  local i
  local x
  # shellcheck disable=SC2034
  for i in $(seq "${1:-1}"); do
    x="$x../"
  done
  cd -- "$x" || return 1
}

# Determine size of a file or total size of a directory
fs() {
  local arg
  if du -b /dev/null > /dev/null 2>&1; then
    arg=-sbh
  else
    arg=-sh
  fi

  if (( $# > 0 )); then
    du "$arg" -- "$@"
  else
    du "$arg" .[^.]* ./*
  fi
}

# ============================================================================
# dev
# ============================================================================

# Update composer packages without cache
cunt() {
  COMPOSER_CACHE_DIR=/dev/null composer update
}

serve() {
  local port
  port="${1:-8888}"

  if dko::has 'python3'; then
    echo "Using python3 http.server"
    python3 -m http.server "$port"
  elif dko::has 'python2'; then
    echo "Using python2 SimpleHTTPServer"
    python2 -m SimpleHTTPServer "$port"
  elif dko::has 'http-server'; then
    echo "Using node http-server"
    http-server -p "$port"
  fi
}

# ============================================================================
# Archiving
# ============================================================================

# Export repo files to specified dir
gitexport() {
  to_dir="${2:-./gitexport}"
  rsync -a "${1:-./}" "$to_dir" --exclude "$to_dir" --exclude .git
}

# ============================================================================
# Network tools
# ============================================================================

mykey() {
  cat "$HOME/.ssh/id_rsa.pub"
  if dko::has "pbcopy"; then
    pbcopy < "$HOME/.ssh/id_rsa.pub"
  elif dko::has "xclip"; then
    xclip "$HOME/.ssh/id_rsa.pub"
  fi
}

# ============================================================================
# macOS/OS X
# ============================================================================

flushdns() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# list members for a group
# http://www.commandlinefu.com/commands/view/10771/osx-function-to-list-all-members-for-a-given-group
members() {
  dscl . -list /Users | while read -r user; do
    printf "%s " "$user"
    dsmemberutil checkmembership -U "$user" -G "$*"
  done | grep "is a member" | cut -d " " -f 1;
}

# short version of what's provided by oh-my-zsh/xcode
ios() {
  open "$(xcode-select -p)/Applications/Simulator.app"
}

vol() {
  if dko::has "osascript"; then
    osascript -e "set volume ${1}"
  fi
}

# Needs to be run from shell iTerm started in
# Modified from
# https://github.com/mhinz/dotfiles/blob/f1cae979e9e72ab414b4c8b3444144c30aa4cde3/.zsh/.zshrc#L448
proftoggle() {
  if [[ -z "$ITERM_PROFILE" ]]; then
    print "Not in iTerm" 1>&2
    return
  fi
  if [[ "$ITERM_PROFILE" == "ZSH - base16 Tomorrow Night" ]]; then
    export ITERM_PROFILE='ZSH - Solarized Light'
  else
    export ITERM_PROFILE='ZSH - base16 Tomorrow Night'
  fi
  local seq="\e]1337;SetProfile=${ITERM_PROFILE}\x7"
  # shellcheck disable=SC2059
  printf "$seq"
  clear
  echo "Now using ${ITERM_PROFILE}"
}

# ============================================================================
# linux
# ============================================================================

# flush linux font cache
flushfonts() {
  fc-cache -f -v
}

# ============================================================================
# misc tools
# ============================================================================

weather() { curl wttr.in/"$1"; }
