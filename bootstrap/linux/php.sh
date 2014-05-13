sudo aptitude install php5-cli php5-json

mkdir -p $HOME/.composer/bin
curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/.composer/bin
