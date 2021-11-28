# shell/aliases-archlinux.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases-archlinux.sh"

# Always create log file
alias makepkg='makepkg --log'

alias pacunlock='sudo rm /var/lib/pacman/db.lck'

alias sysreload='sudo systemctl daemon-reload'

alias verifyfstab='sudo findmnt --verify --verbose'

alias paru-clean-orphans='paru -Qtdq | paru -Rns -'

# It keeps dying on lock!
fixpulse() {
  sudo rm -rf ~/.config/pulse
  systemctl --user start pulseaudio
}

# Get a simple list of installed packages
pacdump() {
  if command -v pamac >/dev/null; then
    pamac list --installed
  else
    pacman -Qqe
  fi
}
