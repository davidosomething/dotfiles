# shell/os-darwin.zsh

# Counting on Darwin default shell to be zsh now, bashisms are okay!

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-darwin.zsh"

# ============================================================================
# homebrew
# ============================================================================

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# just assume brew is in normal location, don't even check for it
export DKO_BREW_PREFIX="/usr/local"

# GOROOT binaries
[ -d "${DKO_BREW_PREFIX}/opt/go/libexec/bin" ] &&
PATH="${DKO_BREW_PREFIX}/opt/go/libexec/bin:${PATH}"
PATH="${DKO_BREW_PREFIX}/opt/git/share/git-core/contrib/git-jump:${PATH}"

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

# iTerm2 bin
PATH="${HOME}/.iterm2:${PATH}"

# ============================================================================
# Functions
# ============================================================================

# list installed brew and deps
# https://zanshin.net/2014/02/03/how-to-list-brew-dependencies/
bwhytree() {
  brew list | while read c; do
    echo -n "\e[1;34m${c} -> \e[0m"
    brew deps "$c" | awk '{printf(" %s ", $0)}'
    echo ""
  done
}

# Restart Docker.app and wait for daemon
dockerrestart() {
  printf "Restarting Docker.app "
  osascript -e 'quit app "Docker"' &
  pid=$!
  wait $pid
  sleep 1

  open -a Docker && {
    while ! docker info >/dev/null 2>&1 ; do
      printf "."
      sleep 1
    done
    echo
  }
}

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

vol() {
  __dko_has "osascript" && osascript -e "set volume ${1}"
}
