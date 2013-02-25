####
# macports stuff, no longer used

export MACPORTS_HOME=/opt/local
export ANT_HOME="$MACPORTS_HOME/share/java/apache-ant"
export APACHE_HOME="$MACPORTS_HOME/apache2"
export PHP_INI="$MACPORTS_HOME/etc/php5/php.ini"
export PATH="$ANT_HOME/bin:$MACPORTS_HOME/bin:$MACPORTS_HOME/sbin:$PATH"

alias portup="sudo port selfupdate && sudo port upgrade outdated"
