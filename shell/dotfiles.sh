# .dotfiles/shell/dotfiles.sh
#
# Update dotfiles and provide instructions for updating the system
# THIS FILE IS SOURCED to give access to current shell
#

# ==============================================================================
# Command functions
# ==============================================================================

# ------------------------------------------------------------------------------
# Meta
# ------------------------------------------------------------------------------

dko::dotfiles::__usage() {
  dko::usage  "u <command>"
  echo "
  Utility Commands
    dotfiles    -- update dotfiles (git pull)
    reload      -- reload this script if it was modified
    secret      -- update ~/.secret (git pull)
    zplug       -- update zplug

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
    macvim      -- install latest brew macvim
    neovim      -- install latest brew neovim/neovim on HEAD

  Development
    vimlint     -- update vimlint
    wpcs        -- update the WordPress-Coding-Standards git repo in src/wpcs
"
}

dko::dotfiles::__reload() {
  source "${DOTFILES}/shell/dotfiles.sh" \
    && dko::status "Reloaded shell/dotfiles.sh"
}

dko::dotfiles::__update() {
  dko::status "Updating dotfiles"
  (
    cd "$DOTFILES" || dko::die "No \$DOTFILES directory"
    git pull --rebase
    dko::status "Updating dotfiles submodules"
    git submodule update --init
  ) || dko::die "Error updating dotfiles"

  dko::dotfiles::__reload
  dko::status "Re-symlink if any dotfiles changed!"

  dko::dotfiles::__zplug
}

dko::dotfiles::__zplug() {
  dko::status "Updating zplug"
  (
    cd "${ZPLUG_HOME}" || dko::die "No \$ZPLUG_HOME"
    git pull
    dko::status "Restart the shell to ensure a clean zplug init"
  )

  [ -n "$ZSH_VERSION" ] && dko::has "zplug" && {
    dko::status "Updating plugins managed by zplug"

    if ! zplug check; then
      dko::status "Installing zplug plugins"
      zplug install
    fi

    zplug update
  }
}

dko::dotfiles::__update_secret() {
  dko::status "Updating secret"
  (
    cd "${HOME}/.secret" || dko::err "No ~/.secret directory"
    git pull --rebase --recurse-submodules \
      && git submodule update --init
  )
}

# ------------------------------------------------------------------------------
# Private utilities
# ------------------------------------------------------------------------------

dko::dotfiles::__pyenv_system() {
  # switch to brew's python (fallback to system if no brew python)
  dko::has "pyenv" \
    && echo \
    && dko::status "Switching to system python to upgrade brew packages" \
    && pyenv shell system
}

# probably don't need this as long as running updates in subshells
dko::dotfiles::__pyenv_global() {
  dko::has "pyenv" \
    && echo \
    && dko::status_ "Switching back to global python" \
    && pyenv shell --unset
}

# ------------------------------------------------------------------------------
# Externals
# ------------------------------------------------------------------------------

dko::dotfiles::__update_composer() {
  (
    dko::has "composer" || dko::die "composer is not installed"

    dko::status "Updating composer itself"
    composer self-update || dko::die "Could not update composer"

    dko::status "Updating composer global packages"
    composer global update || dko::die "Could not update global packages"
  )
  rehash
}

dko::dotfiles::__update_fzf() {
  dko::status "Updating fzf"
  [ -x "/usr/local/bin/fzf" ] \
    && dko::status "fzf was installed via brew (BAD, vim expects in ~/.fzf)" \
    && return 0

  (
    cd "${HOME}/.fzf" || dko::die "Could not cd to ~/.fzf"
    git pull || dko::die "Could not update ~/.fzf"
    ./install --key-bindings --completion --no-update-rc
  )
}

dko::dotfiles::__update_gems() {
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

dko::dotfiles::__update_go() {
  (
    dko::has "go" || dko::die "go is not installed"
    dko::status "Updating go packages"
    go get -u all || dko::die "Could not update go packages"
  )
  rehash
}

dko::dotfiles::__update_node() {
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

dko::dotfiles::__update_nvm() {
  (
    if [ ! -d "$NVM_DIR" ]; then
      dko::status "Installing nvm"
      git clone https://github.com/creationix/nvm.git "$NVM_DIR" \
        || dko::die "Could not install nvm"
    fi

    dko::status "Updating nvm"
    cd "$NVM_DIR" || dko::die "Could not cd to \$NVM_DIR at $NVM_DIR"
    readonly previous_nvm="$(git describe --abbrev=0 --tags)"

    dko::status "Fetching latest nvm"
    { git checkout master && git pull --ff-only; } \
      || dko::die "Could not fetch"
    readonly latest_nvm="$(git describe --abbrev=0 --tags)"

    # Already up to date
    [[ "$previous_nvm" == "$latest_nvm" ]] && exit

    dko::status "Fast-forwarding to latest nvm"
    git checkout --quiet --progress "$latest_nvm" \
      || dko::die "Could not fast-forward"

    # Updated
    exit 3
  )

  case "$?" in
    3)    dko::status "Reloading nvm"
          source "$NVM_DIR/nvm.sh"
          return $?
          ;;
    256)  dko::err "Could not update nvm"
          return 1
          ;;
  esac

  dko::status "Already at latest nvm"
  return 0
}

# $1 pip command (e.g. `pip2`)
dko::dotfiles::__update_pip() {
  local pip_command=${1:-pip}
  dko::status "Updating $pip_command"
  if dko::has "$pip_command"; then
    $pip_command install --upgrade setuptools || return 1
    $pip_command install --upgrade pip        || return 1
    $pip_command list | cut -d' ' -f1 | xargs "$pip_command" install --upgrade
  fi
}

dko::dotfiles::__update_wpcs() {
  readonly wpcs_repo="https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git"
  readonly sources_path="${HOME}/src"
  readonly wpcs_path="${sources_path}/wpcs"

  # --------------------------------------------------------------------------
  # Create and clone wpcs if not exists
  # --------------------------------------------------------------------------

  dko::status "Updating wpcs"
  if [ ! -d "$wpcs_path" ]; then
    mkdir -p "${sources_path}"
    git clone -b master "$wpcs_repo" "$wpcs_path"
  else
    (
      cd "$wpcs_path" || exit 1
      git pull
    ) || return 1
  fi

  if ! dko::has "phpcs"; then
    dko::warn  "phpcs is not installed"
    dko::warn_ "Install and run again, or set installed_paths manually"
    return 1
  fi

  # --------------------------------------------------------------------------
  # Determine installed standards
  # --------------------------------------------------------------------------

  dko::status "Looking for standards"
  readonly possible=( \
    "/usr/local/etc/php-code-sniffer/Standards" \
    "/usr/local/Cellar/php-code-sniffer/2.7.0/CodeSniffer/Standards" \
    "$wpcs_path" \
  )
  local standards=()

  for entry in "${possible[@]}"; do
    [ -d "$entry" ] && \
      echo "Found $entry" && \
      standards+=("$entry")
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

dko::dotfiles::__update_vimlint() {
  readonly sources_path="${HOME}/src"
  readonly vimlint="${sources_path}/vim-vimlint"
  readonly vimlparser="${sources_path}/vim-vimlparser"

  if [ -d "$vimlint" ]; then
    dko::status "Updating vimlint"
    ( cd "$vimlint" && git reset --hard && git pull )
  else
    dko::status "Installing vimlint"
    git clone https://github.com/syngan/vim-vimlint "$vimlint"
  fi

  if [ -d "$vimlparser" ]; then
    dko::status "Updating vimlparser"
    ( cd "$vimlparser" && git reset --hard && git pull )
  else
    dko::status "Installing vimlparser"
    git clone https://github.com/ynkdir/vim-vimlparser "$vimlparser" >/dev/null 2>&1
  fi
}

# ------------------------------------------------------------------------------
# OS-specific commands
# ------------------------------------------------------------------------------

dko::dotfiles::__update_linux() {
  case "$1" in
    arch) dko::dotfiles::__update_arch      ;;
    deb)  dko::dotfiles::__update_deb       ;;
  esac
}

dko::dotfiles::__update_darwin() {
  case "$1" in
    brew)   dko::dotfiles::__update_brew        ;;
    macvim) dko::dotfiles::__update_brew_macvim ;;
    neovim) dko::dotfiles::__update_brew_neovim ;;
    mac)    dko::dotfiles::__update_mac         ;;
  esac
}

# ------------------------------------------------------------------------------
# OS: GNU/Linux: Arch Linux
# ------------------------------------------------------------------------------

dko::dotfiles::__update_arch() {
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

dko::dotfiles::__update_deb() {
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

dko::dotfiles::__update_mac() {
  dko::status "macOS system update"
  sudo softwareupdate --install --all || {
    dko::err "Error updating software permissions"
    return 1
  }
}

dko::dotfiles::__update_brew_done() {
  dko::status "Cleanup old versions and prune dead symlinks"
  brew cleanup
  brew cask cleanup
  brew prune
  rehash
}

dko::dotfiles::__update_brew() {
  dko::status "Updating homebrew"
  (
    dko::has "brew" || dko::die "Homebrew is not installed."

    # enter dotfiles dir to do this in case user has any gem flags or local
    # vendor bundle that will cause use of local gems
    cd "$DOTFILES" \
      || dko::die "Can't enter \$DOTFILES to run brew in clean environment"

    brew update

    # check if needed
    readonly outdated="$(brew outdated --quiet)"
    [ -z "$outdated" ] && exit

    # CLEANROOM
    dko::dotfiles::__pyenv_system
    # Brew some makefiles like macvim use tput for output so need to reset
    # from xterm-256color-italic I use in iterm
    TERM="xterm-256color"

    # Detect if brew's python3 (not pyenv) was outdated
    # Reinstall macvim (in another sub-shell) with new python3 if needed
    grep -q "python3" <<<"$outdated"      \
      && dko::status "Upgrading python3"  \
      && brew upgrade python3             \
      && brew linkapps python3            \
      && dko::status "Rebuilding macvim with new python3" \
      && dko::dotfiles::__update_brew_macvim

    # Update neovim separately
    grep -q "neovim" <<<"$outdated"      \
      && dko::dotfiles::__update_brew_neovim

    # Upgrade remaining
    dko::status "Upgrading packages"
    brew upgrade --all
  ) && dko::dotfiles::__update_brew_done
}

dko::dotfiles::__update_brew_macvim() {
  dko::status "Re-installing macvim via homebrew (brew update first to upgrade)"
  dko::has "brew" || dko::die "Homebrew is not installed."
  (
    # enter dotfiles dir to do this in case user has any gem flags or local
    # vendor bundle that will cause use of local gems
    cd "$DOTFILES" \
      || dko::die "Can't enter \$DOTFILES to run brew in clean environment"

    # CLEANROOM
    dko::dotfiles::__pyenv_system
    TERM=xterm-256color

    brew reinstall macvim --with-lua --with-override-system-vim --with-python3 \
      && dko::status "Linking new macvim.app" \
      && brew linkapps macvim
  )
}

dko::dotfiles::__update_brew_neovim() {
  dko::status "Re-installing neovim via homebrew (brew update first to upgrade)"
  dko::has "brew" || dko::die "Homebrew is not installed."
  (
    # enter dotfiles dir to do this in case user has any gem flags or local
    # vendor bundle that will cause use of local gems
    cd "$DOTFILES" \
      || dko::die "Can't enter \$DOTFILES to run brew in clean environment"

    # CLEANROOM
    dko::dotfiles::__pyenv_system
    TERM=xterm-256color

    brew reinstall --HEAD --with-release neovim
  )
}

# ==============================================================================
# Main
# ==============================================================================

# $1 command
dko::dotfiles() {
  if [[ $# -eq 0 ]]; then
    dko::dotfiles::__usage
    return 1
  fi

  case $1 in
    reload)   dko::dotfiles::__reload           ;;
    dotfiles) dko::dotfiles::__update           ;;
    secret)   dko::dotfiles::__update_secret    ;;
    zplug)    dko::dotfiles::__zplug            ;;
    composer) dko::dotfiles::__update_composer  ;;
    fzf)      dko::dotfiles::__update_fzf       ;;
    gem)      dko::dotfiles::__update_gems      ;;
    go)       dko::dotfiles::__update_go        ;;
    node)     dko::dotfiles::__update_node      ;;
    nvm)      dko::dotfiles::__update_nvm       ;;
    pip)      dko::dotfiles::__update_pip "pip" ;;
    wpcs)     dko::dotfiles::__update_wpcs      ;;
    vimlint)  dko::dotfiles::__update_vimlint   ;;
  esac

  case "$OSTYPE" in
    linux*)   dko::dotfiles::__update_linux   "$1" ;;
    darwin*)  dko::dotfiles::__update_darwin  "$1" ;;
  esac
}

# vim: ft=sh :
