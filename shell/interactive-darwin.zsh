# shell/interactive-darwin.zsh

# Counting on Darwin default shell to be zsh now, bashisms are okay!

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive-darwin.zsh"

# disable /etc/*_Apple_Terminal Terminal.app session integration
export SHELL_SESSIONS_DISABLE=1

# ============================================================================
# homebrew
# ============================================================================

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

__homebrew() {
  # we gotta look in different places for ARM (M1/M2) vs intel macs now :(
  local brew_prefix="/opt/homebrew"
  [ ! -x "${brew_prefix}/bin/brew" ] && brew_prefix="/usr/local"
  if [ -x "${brew_prefix}/bin/brew" ]; then
    eval "$(${brew_prefix}/bin/brew shellenv)"
  else
    return
  fi

  # GOROOT binaries
  [ -d "${HOMEBREW_PREFIX}/opt/go/libexec/bin" ] &&
  PATH="${HOMEBREW_PREFIX}/opt/go/libexec/bin:${PATH}"
  PATH="${HOMEBREW_PREFIX}/opt/git/share/git-core/contrib/git-jump:${PATH}"

  # prefer homebrewed lua@5.1
  [ -x ${HOMEBREW_PREFIX}/bin/luarocks ] &&
    [ -d "${HOMEBREW_PREFIX}/opt/lua@5.1" ] &&
    {
      export DKO_LUA_DIR="${HOMEBREW_PREFIX}/opt/lua@5.1"
      eval "$(luarocks --lua-dir="$DKO_LUA_DIR" path --bin)"
      alias luarocks='luarocks --lua-dir="$DKO_LUA_DIR"'
    }

  # @TODO recheck this for Big Sur
  # https://github.com/pyenv/pyenv/issues/1746
  # Allow pyenv to use custom openssl from brew
  [ -d "${HOMEBREW_PREFIX}/opt/openssl/lib" ] &&
    export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/openssl/lib"
  [ -d "${HOMEBREW_PREFIX}/opt/openssl/include" ] &&
    export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/openssl/include"

  [ -d "${HOMEBREW_PREFIX}/share/android-sdk" ] &&
    export ANDROID_SDK_ROOT="${HOMEBREW_PREFIX}/share/android-sdk"

  # ==========================================================================
  # Homebrew Functions
  # ==========================================================================

  cask-upgrade() {
    local outdated
    outdated=$(brew outdated --cask --greedy --quiet)
    [ -n $outdated ] && brew upgrade $outdated
  }

  # fix old casks that error during uninstall from undent
  # https://github.com/Homebrew/homebrew-cask/issues/49716
  cask-fix-uninstalled() {
    find "$(brew --prefix)/Caskroom/"*'/.metadata' -type f -name '*.rb' |\
      xargs grep 'EOS.undent' --files-with-matches |\
      xargs sed -i '' 's/EOS.undent/EOS/'
  }

  # list installed brew and deps
  # https://zanshin.net/2014/02/03/how-to-list-brew-dependencies/
  bwhytree() {
    brew list -1 --formula | while read c; do
      echo -n "\e[1;34m${c} -> \e[0m"
      brew deps "$c" | awk '{printf(" %s ", $0)}'
      echo ""
    done
  }

  # ==========================================================================
  # Homebrew Aliases
  # ==========================================================================

  alias b='TERM=xterm-256color \brew'
  alias brew='b'

  alias bi='b install'
  alias bs='b search'
  alias blfn='b ls --full-name'

  alias bsvc='b services'
  alias bsvr='b services restart'

  alias bwhy='b uses --installed --recursive'
}
__homebrew

# ============================================================================

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

alias canary='open -a "Google Chrome Canary.app"'
alias chrome='open -a "Google Chrome.app"'
alias slack='open -a Slack.app'

# sudo since we run nginx on port 80 so needs admin
alias rnginx='sudo brew services restart nginx'

# electron apps can't focus if started using Electron symlink
alias elec='/Applications/Electron.app/Contents/MacOS/Electron'

# Audio control - http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"

alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# ----------------------------------------------------------------------------
# xcode
# ----------------------------------------------------------------------------

alias cuios='XCODE_XCCONFIG_FILE="${PWD}/xcconfigs/swift31.xcconfig" carthage update --platform iOS'
alias deletederived='rm -rf ~/Library/Developer/Xcode/DerivedData/*'
alias xcimg='xcrun simctl addmedia booted'
