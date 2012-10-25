sudo pacman -S --needed \
  ack \
  curl \
  git \
  openssh \
  zsh \

if ! which vim >/dev/null 2>&1; then
  sudo pacman -S vim
fi
