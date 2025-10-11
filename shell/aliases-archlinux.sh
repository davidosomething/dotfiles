# shellcheck shell=bash
# shell/aliases-archlinux.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases-archlinux.sh"

alias biosinfo='run0 dmidecode -t bios -q'

alias boot_params='cat /proc/cmdline'

# Always create log file
alias makepkg='makepkg --log'

alias pacunlock='run0 rm /var/lib/pacman/db.lck'

alias sysreload='run0 systemctl daemon-reload'

alias verifyfstab='run0 findmnt --verify --verbose'

alias paru-clean-orphans='paru -Qtdq | paru -Rns -'

# It keeps dying on lock!
fixpulse() {
  run0 rm -rf ~/.config/pulse
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
