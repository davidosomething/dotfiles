#!/bin/zsh

echo
echo "+------------------------------------------------------------------------------+"
echo "| Updating dotfiles, zsh, and vim                                              |"
echo "+------------------------------------------------------------------------------+"
cd ~/.dotfiles
git pull
git submodule update --init --quiet

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
