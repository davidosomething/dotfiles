# .dotfiles/zsh/zshrc-osx.zsh
# sourced by .zshrc

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles
