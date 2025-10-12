#!/bin/bash

# Show commands
set -x

# Install all required packages
yay -Syu --needed - < packages.txt

# Switch shell
chsh -s "$(which zsh)"

# Add Alacritty to Nautilus menu
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# Make Alacritty the default terminal emulator
sudo ln -s /usr/bin/alacritty /usr/bin/xterm

# Enable cronie service for timeshift
sudo systemctl enable cronie.service

# Needed for light
sudo usermod -aG video "$USER"

# Enable locking on suspend
sudo cp ~/.config/systemd_unit_files/lock-on-suspend@.service /etc/systemd/system/
sudo systemctl enable lock-on-suspend@"$USER".service

# Disable the display manager
sudo rm /etc/systemd/system/display-manager.service

# Enable OpenTabletDriver daemon
systemctl --user enable opentabletdriver.service --now

# Add login message
sudo cp ~/.config/login_logo /etc/issue

# Setup GNOME Keyring
sudo cp /etc/pam.d/login /etc/pam.d/login.bak
sudo cp ~/.config/pam_login /etc/pam.d/login

# Setup gtk theme
sudo mkdir /root/.config
sudo mkdir /root/.themes
sudo ln -s ~/.config/gtk-3.0 /root/.config/gtk-3.0
sudo ln -s ~/.config/gtk-4.0 /root/.config/gtk-4.0
sudo ln -s ~/.themes/adw-gtk3-dark /root/.themes/adw-gtk3-dark
sudo ln -s ~/.icons/oreo_white_cursors /usr/share/icons/oreo_white_cursors

# Disable loud system beep
sudo sh -c 'rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf'

# Setup gamemode
sudo usermod -aG gamemode "$USER"

mkdir ~/Pictures/Screenshots
