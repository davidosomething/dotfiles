# .dotfiles/shell/update.sh
#
# Update dotfiles and provide instructions for updating the system
# THIS FILE IS SOURCED
#

# ==============================================================================
# initialize script and dependencies
# ==============================================================================

# get bootstrap folder
source "${DOTFILES}/shell/helpers.sh"

# ==============================================================================
# Command functions
# ==============================================================================

# ------------------------------------------------------------------------------
# Meta
# ------------------------------------------------------------------------------

__dotfiles_usage() {
  dko::usage  "update <command>"
  echo "
  Utility Commands
    dotfiles    -- update dotfiles (git pull)
    reload      -- reload this script if it was modified
    secret      -- update ~/.secret (git pull)

  Shell Tools
    fzf         -- update fzf with flags to not update rc scripts
    node        -- install latest node via nvm
    nvm         -- update nvm installation

  Packages
    composer    -- update composer and global packages
    gem         -- update rubygems and global gems for current ruby
    go          -- golang
    pip         -- update all versions of pip (OS dependent)

  Arch Linux
    arch        -- update arch packages

  Debian/Ubuntu
    deb         -- update apt packages

  macOS/OS X
    brew        -- homebrew packages
    mac         -- repair permissions and check software updates
"
}

__dotfiles_reload() {
  source "${DOTFILES}/shell/update.sh" \
    && dko::status "Reloaded shell/update.sh"
}

__dotfiles_update_dotfiles() {
  dko::status "Updating dotfiles"
  (
    cd "$DOTFILES" || dko::die "No \$DOTFILES directory"
    git pull --rebase || dko::die "Error updating dotfiles"

    {
      dko::status "Updating dotfiles submodules"
      git submodule update --init && __dotfiles_reload
    } || dko::die "Error updating dotfiles submodules"

    [ -n "$ZSH_VERSION" ] && dko::has "zplug" && {
      dko::status "Updating zplug"
      zplug update
    }
  )
}

__dotfiles_update_secret() {
  dko::status "Updating secret"
  (
    cd "${HOME}/.secret" || dko::err "No ~/.secret directory"
    git pull --rebase --recurse-submodules \
      && git submodule update --init
  )
}

# ------------------------------------------------------------------------------
# Externals
# ------------------------------------------------------------------------------

__dotfiles_update_composer() {
  (
    dko::has "composer" || dko::die "composer is not installed"

    dko::status "Updating composer itself"
    composer self-update || dko::die "Could not update composer"

    dko::status "Updating composer global packages"
    composer global update || dko::die "Could not update global packages"
  )
  rehash
}

__dotfiles_update_fzf() {
  dko::status "Updating fzf"
  (
    cd "${HOME}/.fzf" || dko::die "Could not cd to ~/.fzf"
    git pull || dko::die "Could not update ~/.fzf"
    ./install --key-bindings --completion --no-update-rc
  )
}

__dotfiles_update_gems() {
  (
    dko::has "gem" || dko::die "rubygems is not installed"
    [ -z "$RUBY_VERSION" ] && dko::die "System ruby detected! Use chruby."

    dko::status "Updating RubyGems itself for ruby: ${RUBY_VERSION}"
    gem update --system  || dko::die "Could not update RubyGems"

    dko::status "Updating gems"
    gem update || dko::die "Could not update global gems"
  )
  rehash
}

__dotfiles_update_go() {
  (
    dko::has "go" || dko::die "go is not installed"
    dko::status "Updating go packages"
    go get -u all || dko::die "Could not update go packages"
  )
  rehash
}

__dotfiles_update_node() {
  local desired_node="v4"
  local desired_node_minor
  local previous_node

  source "${NVM_DIR}/nvm.sh"
  dko::status "Checking node versions..."
  desired_node_minor="$(nvm version-remote "$desired_node")"
  previous_node="$(nvm current)"

  dko::status_ "Previous node version was $previous_node"
  if [ "$desired_node_minor" != "$previous_node" ]; then
    echo -n "Install and use new node ${desired_node_minor} as default? [y/N] "
    read -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      nvm install             "$desired_node"
      nvm alias default       "$desired_node"

      dko::status_ "Installing npm@latest for $desired_node_minor..."
      npm install --global npm@latest
      rehash

      dko::status "Node and npm updated."
      dko::status_ "Run \$DOTFILES/node/install.sh to install global packages."
    fi
  else
    dko::status_ "Node version is already up-to-date."
  fi
}

__dotfiles_update_nvm() {
  local previous_nvm
  local latest_nvm

  if [ ! -d "$NVM_DIR" ]; then
    dko::status "Installing nvm"
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  fi

  dko::status "Updating nvm"
  cd "$NVM_DIR"  || { dko::err "Could not cd to \$NVM_DIR" && return 1; }

  previous_nvm="$(git describe --abbrev=0 --tags)"
  { git checkout master && git pull; } || {
    dko::err "Could not update nvm"
    cd - || return 1
    return 1;
  }
  latest_nvm="$(git describe --abbrev=0 --tags)"
  git checkout "$latest_nvm" || {
    dko::err "Could not update nvm"
    cd - || return 1
    return 1
  }
  [ "$previous_nvm" != "$latest_nvm" ] && source "$NVM_DIR/nvm.sh"
  cd - || return 1
}

__dotfiles_update_pip() {
  local pip_command=${1:-pip}
  dko::status "Updating $pip_command"
  if dko::has "$pip_command"; then
    $pip_command install --upgrade setuptools || return 1
    $pip_command install --upgrade pip        || return 1
    $pip_command list | cut -d' ' -f1 | xargs "$pip_command" install --upgrade
  fi
}

# ------------------------------------------------------------------------------
# OS-specific commands
# ------------------------------------------------------------------------------

__dotfiles_update_linux() {
  case "$1" in
    arch) __dotfiles_update_arch      ;;
    deb)  __dotfiles_update_deb       ;;
  esac
}

__dotfiles_update_darwin() {
  case "$1" in
    brew) __dotfiles_update_brew      ;;
    mac)  __dotfiles_update_mac       ;;
  esac
}

# ------------------------------------------------------------------------------
# OS: GNU/Linux: Arch Linux
# ------------------------------------------------------------------------------

__dotfiles_update_arch() {
  dko::status "Arch Linux system update"
  if dko::has "pacaur"; then
    # update system
    pacaur -Syu
  elif dko::has "yaourt"; then
    # -Sy         -- get new file list
    yaourt --sync --refresh
    yaourt -Syua
  elif dko::has "aura"; then
    aura -Syua
  else
    pacman -Syu
  fi
}

# ------------------------------------------------------------------------------
# OS: GNU/Linux: Debian or Ubuntu
# ------------------------------------------------------------------------------

__dotfiles_update_deb() {
  dko::status "Apt system update"

  if ! dko::has "apt"; then
    dko::err "Plain 'apt' not found, manually use 'apt-get' for crappy systems."
    exit 1
  fi

  sudo apt update

  # This is for home systems only! Removes unused stuff, same as
  # `apt-get dist-upgrade`
  sudo apt full-upgrade
}

# ------------------------------------------------------------------------------
# OS: macOS/OS X
# ------------------------------------------------------------------------------

__dotfiles_update_mac() {
  dko::status "macOS system update"
  sudo softwareupdate --install --all || {
    dko::err "Error updating software permissions"
    return 1
  }
}

__dotfiles_update_brew_done() {
  dko::status "Cleanup old versions and prune dead symlinks"
  brew cleanup
  brew cask cleanup
  brew prune
  rehash
}

__dotfiles_update_brew() {
  dko::status "Updating homebrew"

  # enter dotfiles dir to do this in case user has any gem flags or local
  # vendor bundle that will cause use of local gems
  cd "$DOTFILES" || {
    dko::err "Can't enter \$DOTFILES to run brew in clean environment"
    cd - || return 1
    return 1
  }

  brew update

  # check if needed
  local outdated=""
  outdated="$(brew outdated --quiet)"
  if [ -z "$outdated" ]; then
    dko::status "All packages up-to-date"
    __dotfiles_update_brew_done
    return
  fi

  # switch to brew's python (fallback to system if no brew python)
  dko::has "pyenv" && pyenv shell system \
    && dko::status_ "Switched to system python"

  dko::status "Upgrade packages"
  brew upgrade --all --cleanup

  # Detect if brew's python3 (not pyenv) was upgraded
  # Reinstall macvim with new python3 if needed
  if echo "$outdated" | grep -q "python3"; then
    __dotfiles_update_python3
    __dotfiles_update_macvim
  fi

  # restore pyenv python
  dko::has "pyenv" && pyenv shell --unset \
    && dko::status_ "Switched to global python"

  cd - || return 1
  __dotfiles_update_brew_done
}

# Must use brew/system python!
__dotfiles_update_python3() {
  dko::status_ "Linking python3 apps"
  brew linkapps python3 || {
    dko::err "Error linking python3" && return 1
  }
}

# Must use brew/system python!
__dotfiles_update_macvim() {
  dko::status_ "Rebuilding macvim for new python3"
  brew reinstall macvim --with-lua --with-override-system-vim --with-python3 \
    || { dko::err "Error reinstalling macvim" && return 1; }
  dko::status_ "Linking new macvim.app"
  brew linkapps macvim
}

# ==============================================================================
# Main
# ==============================================================================

__dotfiles_main() {
  if [[ $# -eq 0 ]]; then
    __dotfiles_usage
    return 1
  fi

  case $1 in
    reload)   __dotfiles_reload           ;;
    dotfiles) __dotfiles_update_dotfiles  ;;
    secret)   __dotfiles_update_secret    ;;
    composer) __dotfiles_update_composer  ;;
    fzf)      __dotfiles_update_fzf       ;;
    gem)      __dotfiles_update_gems      ;;
    go)       __dotfiles_update_go        ;;
    node)     __dotfiles_update_node      ;;
    nvm)      __dotfiles_update_nvm       ;;
    pip)      __dotfiles_update_pip "pip" ;;
  esac

  case "$OSTYPE" in
    linux*)   __dotfiles_update_linux   "$1" ;;
    darwin*)  __dotfiles_update_darwin  "$1" ;;
  esac
}

# vim: ft=sh :
