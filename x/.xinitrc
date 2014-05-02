# .xinitrc is the oldest version, not sure if used anymore
# .xsession is used by some dms
# .xprofile is used by gdm

[[ -f ~/.dotfiles/x/.Xresources ]]  && xrdb ~/.dotfiles/x/.Xresources
[[ -d ~/.dotfiles/solarized ]]      && xrdb -merge ~/.dotfiles/solarized/xresources/solarized

[[ -f ~/.dotfiles/x/.Xmodmap ]]     && xmodmap ~/.dotfiles/x/.Xmodmap
