# installing "packer AUR helper"
sudo pacman -Sy --needed packer

installing "update repositories and packages"
sudo packer -Syu

installing "dependencies via pacman"
sudo packer -S --needed \
  ack \
  curl \
  git \
  openssh \
  zsh

# might have vim-gnome (gvim) installed instead, only install vim if not already
installing "vim via pacman"
command -v vim >/dev/null 2>&1 && sudo packer -S --needed vim
