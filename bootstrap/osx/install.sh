#!/usr/bin/env bash

mac_dotfiles="${HOME}/.dotfiles/mac"

# .hushlogin -- hide last login time when opening new term
ln -sf "${mac_dotfiles}/.hushlogin" "${HOME}/.hushlogin"

