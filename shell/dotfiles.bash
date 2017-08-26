# .dotfiles/shell/dotfiles.bash
#
# Update dotfiles and provide instructions for updating the system
# THIS FILE IS SOURCED to give access to current shell
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/dotfiles.bash"

# ==============================================================================
# Command functions
# ==============================================================================

# ------------------------------------------------------------------------------
# Meta
# ------------------------------------------------------------------------------

__dko::dotfiles::usage() {
  dko::usage  "u <command>"
  echo '
  Utility Commands
    dotfiles    -- update dotfiles (git pull); then reload; then zplugin
    reload      -- reload this script if it was modified
    secret      -- update ~/.secret (git pull)
    zplugin     -- update zplugin
    daily       -- update everything except dotfiles and apt/brew/pac

  Shell Tools
    fzf         -- update fzf with flags to not update rc scripts
    node        -- install latest node via nvm
    nvm         -- update nvm installation
    pyenv       -- update pyenv installation

  Packages
    composer    -- update composer and global packages
    gem         -- update rubygems and global gems for current ruby
    go          -- golang
    pip         -- update all versions of pip (OS dependent)
    neopy       -- update neovim pyenvs

  Arch Linux
    arch        -- update arch packages

  Debian/Ubuntu
    deb         -- update apt packages

  macOS/OS X
    brew        -- homebrew packages
    mac         -- repair permissions and check software updates

  Development
    vimlint     -- update vimlint
    wpcs        -- update the WordPress-Coding-Standards git repo in src/wpcs
'
}

__dko::dotfiles::reload() {
  . "${DOTFILES}/shell/dotfiles.bash" || return 1
  dko::ok "Reloaded shell/dotfiles.bash"
}

__dko::dotfiles::cd() {
  cd "$DOTFILES" || {
    dko::err "No \$DOTFILES directory"
    return 1
  }
}

__dko::dotfiles::update() {
  dko::status "Updating dotfiles"

  local lockfile="${LDOTDIR}/dotfiles.lock"
  # shellcheck disable=SC2064
  trap "rm -f \"$lockfile\"" EXIT
  touch "$lockfile"

  (
    __dko::dotfiles::cd || exit 1
    git pull --rebase || exit 1
    git log --no-merges --abbrev-commit --oneline ORIG_HEAD..
    dko::status "Updating dotfiles submodules"
    git submodule update --init || exit 1
  ) || {
    dko::err "Error updating dotfiles"
    return 1
  }

  __dko::dotfiles::reload
  dko::status "Re-symlink if any dotfiles changed!"

  __dko::dotfiles::update_zplugin
}

__dko::dotfiles::update_zplugin() {
  dko::has 'zplugin' && {
    dko::status "Updating zplugin"
    # Remove zplug
    [ -d "${XDG_DATA_HOME}/zplug" ] && rm -rf "${XDG_DATA_HOME}/zplug"
    zplugin self-update
    zplugin update --all
  }
}

__dko::dotfiles::cd_secrets() {
  cd "${HOME}/.secret" || {
    dko::err "No ~/.secret directory"
    return 1
  }
}

__dko::dotfiles::update_secret() {
  dko::status "Updating secret"
  (
    __dko::dotfiles::cd_secrets || return 1
    git pull --rebase --recurse-submodules \
    && git log --no-merges --abbrev-commit --oneline ORIG_HEAD.. \
    && git submodule update --init
  )
}

__dko::dotfiles::update_daily() {
  __dko::dotfiles::update_secret
  __dko::dotfiles::php::update_composer
  __dko::dotfiles::update_fzf
  __dko::dotfiles::ruby::update_gems
  __dko::dotfiles::node::update_nvm
  __dko::dotfiles::py::update_pip "pip"
  __dko::dotfiles::py::update_pyenv
  __dko::dotfiles::py::update_neovim_python
  __dko::dotfiles::vim::update_vimlint
  __dko::dotfiles::php::update_wpcs
}

# ------------------------------------------------------------------------------
# Private utilities
# ------------------------------------------------------------------------------

__dko::dotfiles::pyenv_system() {
  # switch to brew's python (fallback to system if no brew python)
  dko::has "pyenv" \
    && dko::status "Switching to system python to upgrade brew packages" \
    && pyenv shell system
}

# probably don't need this as long as running updates in subshells
__dko::dotfiles::pyenv_global() {
  dko::has "pyenv" \
    && dko::status_ "Switching back to global python" \
    && pyenv shell --unset
}

# ------------------------------------------------------------------------------
# Externals
# ------------------------------------------------------------------------------

__dko::dotfiles::update_fzf() {
  local installer

  if [ -x "/usr/local/opt/fzf/install" ]; then
    dko::status "fzf was installed via brew, re-running installer"
    installer="/usr/local/opt/fzf/install"
  elif [ -d "$HOME/.fzf" ]; then
    dko::status "fzf was installed in ~/.fzf"
    installer="$HOME/.fzf/install"
    ( cd "${HOME}/.fzf" || { dko::err "Could not cd to ~/.fzf" && exit 1; }
      dko::status "Updating fzf"
      git pull || { dko::err "Could not update ~/.fzf" && exit 1; }
      git log --no-merges --abbrev-commit --oneline ORIG_HEAD..
    ) || return 1
  else
    dko::err "fzf is not installed"
    return 1
  fi

  # Install/update shell extensions
  if [[ -n "$installer" ]]; then
    dko::status "Updating fzf shell extensions"
    "$installer" --key-bindings --completion --no-update-rc || return 1
  fi
}

# ----------------------------------------------------------------------------
# Ruby: Introspection
# ----------------------------------------------------------------------------

__dko::dotfiles::ruby::require_chruby() {
  [ -n "$RUBY_VERSION" ] && return 0
  dko::warn "System ruby detected! Please install and use chruby."
  return 1
}

__dko::dotfiles::ruby::require_rubygems() {
  dko::has "gem" && return 0
  dko::warn "rubygems is not installed"
  return 1
}

# ----------------------------------------------------------------------------
# Ruby: Update Gems
# ----------------------------------------------------------------------------

__dko::dotfiles::ruby::update_gems() {
  dko::status "Updating gems"
  __dko::dotfiles::ruby::require_chruby || return 1
  __dko::dotfiles::ruby::require_rubygems || return 1

  dko::status "Updating RubyGems itself for ruby: ${RUBY_VERSION}"
  gem update --system  || {
    dko::err "Could not update RubyGems"
    return 1
  }

  gem update || {
    dko::err "Could not update gems"
    return 1
  }
}

# ----------------------------------------------------------------------------
# Go
# ----------------------------------------------------------------------------

__dko::dotfiles::go::require_go() {
  dko::has "go" && return 0
  dko::warn "go is not installed"
  return 1
}

__dko::dotfiles::go::update_go() {
  dko::status "Updating go packages"
  __dko::dotfiles::go::require_go || return 1
  go get -u all || {
    dko::err "Could not update go packages"
    return 1
  }
}

# ----------------------------------------------------------------------------
# Node: Introspection
# ----------------------------------------------------------------------------

__dko::dotfiles::node::require_nvm() {
  if [ -z "$NVM_DIR" ]; then
    dko::err "\$NVM_DIR is not defined, make sure rc files are linked."
    return 1
  fi

  if [ ! -d "$NVM_DIR" ]; then
    dko::status "Installing nvm"
    git clone https://github.com/creationix/nvm.git "$NVM_DIR" \
      || { dko::err "Could not install nvm" && return 1; }
  fi
}

# ----------------------------------------------------------------------------
# Node: Update node to latest stable
# ----------------------------------------------------------------------------

__dko::dotfiles::update_node() {
  local desired_node="v6"
  local desired_node_minor
  local previous_node

  __dko::dotfiles::node::require_nvm || return 1

  . "${NVM_DIR}/nvm.sh"
  dko::status "Checking node versions..."
  desired_node_minor="$(nvm version-remote "$desired_node")"
  previous_node="$(nvm current)"

  dko::status_ "Previous node version was $previous_node"
  if [ "$desired_node_minor" != "$previous_node" ]; then
    echo -n "Install and use new node ${desired_node_minor} as default? [y/N] "
    read -r
    echo
    if [ "$REPLY" = "y" ]; then
      nvm install             "$desired_node"
      nvm alias default       "$desired_node"

      dko::status_ "Installing npm@latest for $desired_node_minor..."
      npm install --global npm@latest
      rehash

      dko::ok "Node and npm updated."
      dko::ok_ "Run \$DOTFILES/node/install.sh to install global packages."
    fi
  else
    dko::ok "Node version is already up-to-date."
  fi
}

# ----------------------------------------------------------------------------
# Node: Update NVM
# ----------------------------------------------------------------------------

__dko::dotfiles::node::update_nvm() {
  __dko::dotfiles::node::require_nvm || return 1

  (
    cd "$NVM_DIR" || exit 1

    dko::status "Updating nvm"
    readonly previous_nvm="$(git describe --abbrev=0 --tags)"

    dko::status_ "Found nvm ${previous_nvm}"
    { git checkout master && git pull --tags; } \
      || { dko::err "Could not fetch" && exit 1; }
    readonly latest_nvm="$(git describe --abbrev=0 --tags)"
    # Already up to date
    [ "$previous_nvm" = "$latest_nvm" ] \
      && { dko::ok "Already have nvm ${latest_nvm}" && exit 0; }

    dko::status "Fast-forwarding to nvm ${latest_nvm}"
    git checkout --quiet --progress "$latest_nvm" \
      || { dko::err "Could not fast-forward" && exit 1; }

    exit 0
  ) || return 1

  dko::status "Reloading nvm"
  . "$NVM_DIR/nvm.sh"
}

# ----------------------------------------------------------------------------
# Python
# ----------------------------------------------------------------------------

__dko::dotfiles::py::update_pyenv() {
  if [ -n "$PYENV_ROOT" ] && [ -d "${PYENV_ROOT}/.git" ]; then
    dko::status "Updating pyenv"
    ( cd "${PYENV_ROOT}" || exit 1
      pyenv update
    ) || return 1
  else
    dko::warn "pyenv was not installed using pyenv-installer"
  fi
}

# $1 pip command (e.g. `pip2`)
__dko::dotfiles::py::update_pip() {
  local pip_command=${1:-pip}
  dko::status "Updating $pip_command"
  if dko::has "$pip_command"; then
    $pip_command install --upgrade setuptools || return 1
    $pip_command install --upgrade pip        || return 1
    $pip_command install --upgrade \
      --requirement "${DOTFILES}/python/requirements.txt"
  fi
}

__dko::dotfiles::py::update_neovim_python() {
  dko::status "Updating neovim2"
  pyenv activate neovim2 && pip install --upgrade neovim
  dko::status "Updating neovim3"
  pyenv activate neovim3 && pip install --upgrade neovim
  pyenv deactivate
}

# ----------------------------------------------------------------------------
# PHP
# ----------------------------------------------------------------------------

__dko::dotfiles::php::require_composer() {
  dko::has "composer" && return 0
  dko::warn "composer is not installed"
  return 1
}

__dko::dotfiles::php::update_composer() {
  __dko::dotfiles::php::require_composer || return 1

  dko::status "Updating composer"
  if [ -x "/usr/local/bin/composer" ]; then
    dko::ok "composer was installed via brew (yay)"
  else
    dko::status_ "Updating composer itself"
    composer self-update || {
      dko::err "Could not update composer"
      return 1
    }
  fi

  if [ -f "$COMPOSER_HOME/composer.json" ]; then
    dko::status "Updating composer global packages"
    composer global update || {
      dko::err "Could not update global packages"
      return 1
    }
  fi
}

__dko::dotfiles::php::require_phpcs() {
  dko::has "phpcs" && return 0
  dko::warn  "phpcs is not installed"
  dko::warn_ "Install via composer global require and run again, or set installed_paths manually"
  return 1
}

__dko::dotfiles::php::update_wpcs() {
  readonly wpcs_repo="https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git"
  readonly sources_path="${HOME}/src"
  readonly wpcs_path="${sources_path}/wpcs"

  # --------------------------------------------------------------------------
  # Create and clone wpcs if not exists
  # --------------------------------------------------------------------------

  dko::status "Updating wpcs"
  __dko::dotfiles::php::require_composer || return 1
  __dko::dotfiles::php::require_phpcs || return 1

  if [ ! -d "$wpcs_path" ]; then
    mkdir -p "${sources_path}"
    git clone -b master "$wpcs_repo" "$wpcs_path"
  else
    ( cd "$wpcs_path" || exit 1
      git pull \
      && git log --no-merges --abbrev-commit --oneline ORIG_HEAD..
    ) || return 1
  fi

  # --------------------------------------------------------------------------
  # Determine installed standards
  # --------------------------------------------------------------------------

  dko::status "Looking for standards"
  readonly possible=( \
    "$COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards" \
    "$wpcs_path" \
  )
  local standards=()

  for entry in "${possible[@]}"; do
    [ -d "$entry" ] && echo "Found $entry" && standards+=("$entry")
  done
  standards_path=$( IFS=','; echo "${standards[*]}" )

  # --------------------------------------------------------------------------
  # Update config
  # --------------------------------------------------------------------------

  dko::status "Updating standards path to:"
  echo "    ${standards_path}"
  phpcs --config-set installed_paths "$standards_path"

  # List installed standards:
  phpcs -i
  phpcs --config-set default_standard PSR2
}

# ----------------------------------------------------------------------------
# Vim
# ----------------------------------------------------------------------------

__dko::dotfiles::vim::update_vimlint() {
  readonly sources_path="${HOME}/src"
  readonly vimlint="${sources_path}/vim-vimlint"
  readonly vimlparser="${sources_path}/vim-vimlparser"

  if [ -d "$vimlint" ]; then
    dko::status "Updating vimlint"
    ( cd "$vimlint" \
      && git reset --hard \
      && git pull \
      && git log --no-merges --abbrev-commit --oneline ORIG_HEAD..
    )
  else
    dko::status "Installing vimlint"
    git clone https://github.com/syngan/vim-vimlint "$vimlint"
  fi

  if [ -d "$vimlparser" ]; then
    dko::status "Updating vimlparser"
    ( cd "$vimlparser" \
      && git reset --hard \
      && git pull \
      && git log --no-merges --abbrev-commit --oneline ORIG_HEAD..
    )
  else
    dko::status "Installing vimlparser"
    git clone https://github.com/ynkdir/vim-vimlparser "$vimlparser" >/dev/null 2>&1
  fi
}

# ------------------------------------------------------------------------------
# OS-specific commands
# ------------------------------------------------------------------------------

__dko::dotfiles::linux::update() {
  case "$1" in
    arch) __dko::dotfiles::linux::arch::update ;;
    deb)  __dko::dotfiles::linux::deb::update ;;
  esac

  return $?
}

__dko::dotfiles::darwin::update() {
  case "$1" in
    brew)   __dko::dotfiles::darwin::update_brew ;;
    mac)    __dko::dotfiles::darwin::update_mac  ;;
  esac

  return $?
}

# ------------------------------------------------------------------------------
# OS: GNU/Linux: Arch Linux
# ------------------------------------------------------------------------------

__dko::dotfiles::linux::arch::update() {
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

__dko::dotfiles::linux::deb::update() {
  dko::status "Apt system update"

  if ! dko::has "apt"; then
    dko::err "Plain 'apt' not found, manually use 'apt-get' for crappy systems."
    return 1
  fi

  sudo apt update

  # This is for home systems only! Removes unused stuff, same as
  # `apt-get dist-upgrade`
  sudo apt full-upgrade
}

# ------------------------------------------------------------------------------
# OS: macOS/OS X
# ------------------------------------------------------------------------------

__dko::dotfiles::darwin::update_mac() {
  dko::status "macOS system update"
  sudo softwareupdate --install --all

  dko::status "xcode and cli update"
  sudo xcode-select --install

  dko::has "mas" && mas upgrade
}

__dko::dotfiles::darwin::update_brew_done() {
  dko::status "Cleanup old versions and prune dead symlinks"
  brew cleanup
  brew cask cleanup
  brew prune
  rehash
}

__dko::dotfiles::darwin::require_brew() {
  dko::has "brew" && return 0
  dko::warn "Homebrew is not installed."
  return 1
}

__dko::dotfiles::darwin::update_brew() {
  __dko::dotfiles::darwin::require_brew || return 1

  dko::status "Updating homebrew"
  (
    # CLEANROOM
    # enter dotfiles dir to do this in case user has any gem flags or local
    # vendor bundle that will cause use of local gems
    __dko::dotfiles::cd || exit 1
    __dko::dotfiles::pyenv_system
    # Brew some makefiles like macvim use tput for output so need to reset
    # from xterm-256color-italic I use in iterm
    TERM="xterm-256color"

    # we use & wait on brew since they sometimes spawn

    brew update & wait

    # check if needed
    readonly outdated="$(brew outdated --quiet & wait)"
    [ -z "$outdated" ] && exit

    # Detect if brew's python3 (not pyenv) was outdated
    grep -q "python3" <<<"$outdated" && {
      dko::status "Python3 was outdated, upgrading python3"
      brew upgrade python3 &
      wait
    }

    # Upgrade remaining
    dko::status "Upgrading packages"
    brew upgrade

    # If imagemagick was outdated and php-imagick was not, force a reinstall
    # of php-imagick from source (using the new imagemagick)
    if grep -q "imagemagick" <<<"$outdated"; then
      readonly phpimagick="$(brew ls | grep 'php.*imagick')"
      [ -n "$phpimagick" ] \
        && dko::status "Rebuilding ${phpimagick} for new imagemagick" \
        && brew reinstall --build-from-source "$phpimagick"
    fi

    # link curl
    if grep -q curl <<<"$outdated"; then
      brew link --force curl
    fi

  ) && __dko::dotfiles::darwin::update_brew_done
}

# ==============================================================================
# Main
# ==============================================================================

# $1 command
dko::dotfiles() {
  if (( $# == 0 )); then
    __dko::dotfiles::usage
    return 1
  fi

  case $1 in
    reload)   __dko::dotfiles::reload               ;;
    dotfiles) __dko::dotfiles::update               ;;
    secret)   __dko::dotfiles::update_secret        ;;
    zplugin)  __dko::dotfiles::update_zplugin       ;;
    daily)    __dko::dotfiles::update_daily         ;;
    composer) __dko::dotfiles::php::update_composer ;;
    fzf)      __dko::dotfiles::update_fzf           ;;
    gem)      __dko::dotfiles::ruby::update_gems    ;;
    go)       __dko::dotfiles::go::update_go        ;;
    node)     __dko::dotfiles::update_node          ;;
    nvm)      __dko::dotfiles::node::update_nvm     ;;
    pip)      __dko::dotfiles::py::update_pip "pip" ;;
    pyenv)    __dko::dotfiles::py::update_pyenv           ;;
    neopy)    __dko::dotfiles::py::update_neovim_python   ;;
    vimlint)  __dko::dotfiles::vim::update_vimlint        ;;
    wpcs)     __dko::dotfiles::php::update_wpcs     ;;

    *)
      case "$OSTYPE" in
        linux*)   __dko::dotfiles::linux::update "$1"   ;;
        darwin*)  __dko::dotfiles::darwin::update "$1"  ;;
      esac
  esac

  return $?
}
