TODO
====

* Add dotfiles selfupdate
* Make BASH compatible
* Use getopts to get opts
* Break install into multiple files
* Symlink only if filename has .symlink (a la zach holman)
* Check for ruby
  * Install RVM and ruby-build
  * Install Homebrew
  * Brew stuff
* Create branches for archlinux and ubuntu testing, move Vagrantfiles there


New order
---------

### Requirements check

1. Check OS
2. Determine package manager
  * Offer to install
  * Set package manager installed var
3. Check for required binaries (e.g. git)
  * Offer to install if package manager installed
  * Set binaries found or exit

### Update phase

4. If binaries found, git pull
5. If vundle in .vimrc, update vim bundles

### Extras phase

6. Check for each thing to set up
  * Offer to install

### Shell phase

7. Check for zsh. Ask if want to change to ZSH
8. exec $shell
