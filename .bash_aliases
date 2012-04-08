# ~/.dotfiles/.bash_aliases
# sourced by both .zshrc and .bashrc, so keep it bash compatible
alias ..='cd ..'
alias ....='cd ../..'
alias dirs="dirs -v"                  # default to vert, use -l for list

alias vi="vim"
alias vim="vim -p"                    # open in tabs by default

alias grep='grep --color=auto --exclude-dir=\.svn'

alias hosts="sudo $EDITOR /etc/hosts"
alias phpini="sudo $EDITOR $PHP_INI"
alias apacheconf="sudo $EDITOR $APACHE_HOME/conf/httpd.conf"
alias vhosts="sudo $EDITOR $APACHE_HOME/conf/extra/httpd-vhosts.conf"
alias apache2ctl="sudo $APACHE_HOME/bin/apachectl"
alias apacheerrors="tail $APACHE_HOME/logs/error_log"
alias wget="wget --no-check-certificate"
alias publicip="curl icanhazip.com"
alias remux="if tmux has 2>/dev/null; then tmux attach; else tmux new $SHELL; fi"
alias demux="tmux detach"
