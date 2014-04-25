# .dotfiles/zsh/zshrc-osx.zsh
# sourced by .zshrc

command -v brew >/dev/null 2>&1 && {
  export _Z_CMD=j
  source_if_exists "`brew --prefix`/etc/profile.d/z.sh"
}

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles
