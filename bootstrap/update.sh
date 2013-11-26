#!/usr/bin/env bash
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

# Make sure there are no untracked changes before updating dotfiles
if [[ ! -n $(evil_git_num_untracked_files) ]]; then
  dkodie "You have unsaved changes in your ~/.dotfiles folder."
fi

# Update dotfiles
dkostatus "Jumping to dotfiles directory" && pushd $HOME/.dotfiles >> /dev/null
dkostatus "Getting latest updates" && git stash && git pull --rebase --recurse-submodules && git stash apply
dkostatus "Back to original directory" popd >> /dev/null

dkostatus "You should run these commands as needed:"
if [[ $OSTYPE = "linux-gnu" ]]; then
  echo "wpcliup                       # update wp-cli"

else
  echo "diskutil repairPermissions /  # fix file system permissions"
  echo "sysup                         # alias for osx software update"
  echo "brew doctor"
  echo "brew update"
  echo "brew upgrade"
  echo "brew cleanup"
fi

echo "gem update --system"
echo "gem update"
echo "gem clean"
echo "npm update -g"
echo "heroku update"
echo "vimup"                        # alias that updates vim plugins"
