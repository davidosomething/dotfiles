a2() { sudo service apache2 $@ }
a2r() { sudo service apache2 restart }
composer() { php $HOME/.composer/bin/composer.phar $@ }
# gui
open() { xdg-open $@ }
