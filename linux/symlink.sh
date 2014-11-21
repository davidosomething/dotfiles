echo "Run these"

cat <<EOF
ln -sf ~/.dotfiles/linux/x/.xprofile ~/.xprofile
ln -sf ~/.dotfiles/linux/x/.xinitrc ~/.xsession
ln -sf ~/.dotfiles/linux/x/.xinitrc ~/.xinitrc
ln -sf ~/.dotfiles/linux/tint2/tint2rc ~/.config/tint2/tint2rc
ln -sf ~/.dotfiles/linux/openbox/rc.xml ~/.config/openbox/rc.xml
ln -sf ~/.dotfiles/linux/openbox/menu.xml ~/.config/openbox/menu.xml
ln -sf ~/.dotfiles/linux/openbox/autostart ~/.config/openbox/autostart
ln -sf ~/.dotfiles/linux/nautilus/accels ~/.config/nautilus/accels
EOF

