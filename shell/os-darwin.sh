# shell/os-darwin.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-darwin.sh"

# ============================================================================
# homebrew
# ============================================================================

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS='--require-sha'

# just assume brew is in normal location, don't even check for it
export DKO_BREW_PREFIX="/usr/local"

# GOROOT binaries
[ "$DOTFILES_OS" = "Darwin" ] &&
  [ -d "${DKO_BREW_PREFIX}/opt/go/libexec/bin" ] &&
  PATH="${DKO_BREW_PREFIX}/opt/go/libexec/bin:${PATH}"

[ "$DOTFILES_OS" = "Darwin" ] &&
  PATH="${DKO_BREW_PREFIX}/opt/git/share/git-core/contrib/git-jump:${PATH}"

export PATH

# prefer homebrewed lua@5.1
command -v luarocks >/dev/null &&
  [ -d "${DKO_BREW_PREFIX}/opt/lua@5.1" ] &&
  {
    export DKO_LUA_DIR="${DKO_BREW_PREFIX}/opt/lua@5.1"
    eval "$(luarocks --lua-dir="$DKO_LUA_DIR" path --bin)"
    alias luarocks='luarocks --lua-dir="$DKO_LUA_DIR"'
  }

# Allow pyenv to use custom openssl from brew
[ -d "${DKO_BREW_PREFIX}/opt/openssl/lib" ] &&
  export LDFLAGS="-L${DKO_BREW_PREFIX}/opt/openssl/lib"
[ -d "${DKO_BREW_PREFIX}/opt/openssl/include" ] &&
  export CPPFLAGS="-I${DKO_BREW_PREFIX}/opt/openssl/include"

[ -d "${DKO_BREW_PREFIX}/share/android-sdk" ] &&
  export ANDROID_SDK_ROOT="${DKO_BREW_PREFIX}/share/android-sdk"

# ============================================================================
# Functions
# ============================================================================

flushdns() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# short version of what's provided by oh-my-zsh/xcode
ios() {
  open "$(xcode-select -p)/Applications/Simulator.app"
}

# list members for a group
# http://www.commandlinefu.com/commands/view/10771/osx-function-to-list-all-members-for-a-given-group
members() {
  dscl . -list /Users | while read -r user; do
    printf "%s " "$user"
    dsmemberutil checkmembership -U "$user" -G "$*"
  done | grep "is a member" | cut -d " " -f 1
}

proftoggle() {
  if [ -z "$ITERM_PROFILE" ]; then
    print "Not in iTerm" 1>&2
    return
  fi

  if [[ "$ITERM_PROFILE" == "ZSH - base16 Tomorrow Night" ]]; then
    ITERM_PROFILE='ZSH - Solarized Light'
  else
    ITERM_PROFILE='ZSH - base16 Tomorrow Night'
  fi
  export ITERM_PROFILE

  seq="\e]1337;SetProfile=${ITERM_PROFILE}\x7"
  # shellcheck disable=SC2059
  printf "$seq"

  echo
  echo "Now using ${ITERM_PROFILE}"
}

vol() {
  __dko_has "osascript" && osascript -e "set volume ${1}"
}
