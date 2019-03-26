# shell/aliases-archlinux.bash

alias paclast="expac --timefmt='%Y-%m-%d %T' '%l\\t%n' | sort | tail -20"

if command -v pacaur >/dev/null; then
  alias b='pacaur'
fi
alias bi='b -S'
alias bq='b -Qs'
alias bs='b -Ss'

# Always create log file
alias makepkg='makepkg --log'

alias rphp='sudo systemctl restart php-fpm.service'
alias rnginx='sudo systemctl restart nginx.service'
