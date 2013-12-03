#!/bin/bash
#
# Update dotfiles and provide instructions for updating the system

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
pushd "$(dirname $0)"/.. >> /dev/null
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh
popd >> /dev/null

##
# Return number of untracked files in git
function evil_git_num_untracked_files {
  expr `git status --porcelain 2>/dev/null| grep "^??" | wc -l`
}

if [ $# -eq 0 ]; then
  dkostatus "Updating dotfiles"
  # Make sure there are no untracked changes before updating dotfiles
  if [[ $(evil_git_num_untracked_files) ]]; then
    dkodie "You have unsaved changes in your ~/.dotfiles folder."
  fi

  # Update dotfiles
  dkostatus_ "  Jumping to dotfiles directory" && pushd $HOME/.dotfiles >> /dev/null
  dkostatus_ "  Getting latest updates" && git pull --rebase --recurse-submodules && git submodule update
  dkostatus_ "  Back to original directory" popd >> /dev/null
fi

dkostatus "You should run these commands as needed:"
if [[ $OSTYPE = "linux-gnu" ]]; then
  echo "[linux only]"
  echo "wpcliup                       # update wp-cli"
  echo "rbenv update                  # update rbenv and installed gems"

else
  echo "[osx only]"
  echo "diskutil repairPermissions /  # fix file system permissions"
  echo "sysup                         # alias for osx software update"

  if [[ "$1" = "brew" ]]; then
    brew doctor && brew update && brew upgrade && brew cleanup

  else
    echo "brew doctor"
    echo "brew update"
    echo "brew upgrade"
    echo "brew cleanup"
  fi
fi

echo "[common]"

if [[ "$1" = "gem" ]]; then
  gem update --system && gem update && gem clean
else
  echo "gem update --system"
  echo "gem update"
  echo "gem clean"
fi

echo "npm update -g"
echo "heroku update"
echo "vimup"                        # alias that updates vim plugins"
