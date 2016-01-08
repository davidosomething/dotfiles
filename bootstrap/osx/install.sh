#!/usr/bin/env bash

osx_dotfiles="${HOME}/.dotfiles/osx"

# .hushlogin -- hide last login time when opening new term
ln -sf "${osx_dotfiles}/.hushlogin" "${HOME}/.hushlogin"

