# install locally
if [[ "$1" = "--local" ]]; then
  mkdir -p $HOME/.composer/bin
  curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/.composer/bin
  exit 0

elif [[ $EUID -ne 0 ]]; then
  echo "Pass --local to install locally, or run as root to install globally." 1>&2
  exit 1

# install globally
else
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  exit 0

fi
