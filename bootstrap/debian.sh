. $DOTFILES_BOOTSTRAP_FOLDER/helpers.sh

echo "Assuming that sudo is already installed..."

status "Installing dependencies"
sudo aptitude install \
  curl \
  git \
  openssh-client \
  vim \
  zsh \
