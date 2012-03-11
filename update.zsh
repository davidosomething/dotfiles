#!/bin/zsh

echo
echo "+------------------------------------------------------------------------------+"
echo "| Updating zsh                                                                 |"
echo "+------------------------------------------------------------------------------+"
cd ~/.dotfiles
git pull
git submodule update

if [[ -x ~/.vim/update.sh ]]; then
  cd ~/.vim
  echo
  echo "+------------------------------------------------------------------------------+"
  echo "| Updating .vim folder and .vimrc                                              |"
  echo "+------------------------------------------------------------------------------+"
  git pull                            # update vim folder and vimrc itself
  ~/.vim/update.sh                    # update submodules
fi

if [[ -d ~/.rbenv ]]; then
  cd ~/.rbenv
  echo
  echo "+------------------------------------------------------------------------------+"
  echo "| Updating .rbenv                                                              |"
  echo "+------------------------------------------------------------------------------+"
  git pull
fi

echo
echo "DONE!"
echo
