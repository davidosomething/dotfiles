a2() {
  sudo service apache2 $@
}

a2r() {
  sudo service apache2 restart
}

# gui
open() { xdg-open $@ }
