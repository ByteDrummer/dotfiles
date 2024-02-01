#!/bin/bash

# Show commands
set -x

# Install all required packages
yay -Syu --needed - < packages.txt

# Switch shell
chsh -s $(which zsh)

# Add Alacritty to Nautilus menu
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# Enable cronie service for timeshift
sudo systemctl enable cronie.service

# Needed for light
sudo usermod -aG video $USER

# Enable locking on suspend
sudo cp ~/.config/systemd_unit_files/lock-on-suspend@.service /etc/systemd/system/
sudo systemctl enable lock-on-suspend@$(whoami).service

# Disable the display manager
sudo rm /etc/systemd/system/display-manager.service

# Add login message
sudo cp ~/.config/wired /etc/issue

# Setup gtk theme
sudo mkdir /root/.config
sudo mkdir /root/.themes
sudo ln -s ~/.config/gtk-3.0 /root/.config/gtk-3.0
sudo ln -s ~/.config/gtk-4.0 /root/.config/gtk-4.0
sudo ln -s ~/.themes/adw-gtk3-dark /root/.themes/adw-gtk3-dark
sudo ln -s ~/.icons/oreo_white_cursors /usr/share/icons/oreo_white_cursors

# Disable loud system beep
sudo sh -c 'rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf'

mkdir ~/Pictures/Screenshots
