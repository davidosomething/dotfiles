installing "pacman required packages for packer"
sudo pacman -S --needed base-devel fakeroot git

# installing "packer AUR helper"
# [[ -d "$HOME/src/packer" ]] || mkdir -p $HOME/src

installing "update repositories and packages"
# sudo packer -Syu
sudo pacman -Syu

installing "dependencies via pacman"
sudo pacman -S --needed \
  ack \
  curl \
  git \
  openssh \
  tmux \
  zsh

# might have vim-gnome (gvim) installed instead, only install vim if not already
installing "vim via pacman"
[ ! which vim >/dev/null ] && sudo pacman -S --needed vim
