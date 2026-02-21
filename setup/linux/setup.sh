#!/bin/bash

# Show commands
set -x

# Stop script on error
set -e

# Copy dotfiles
chezmoi apply

# Install all required packages
xargs -a packages.txt paru -Syu --needed

# Switch shell
chsh -s "$(which zsh)"

# Add Alacritty to Nautilus menu
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# Make Alacritty the default terminal emulator
sudo ln -sf /usr/bin/alacritty /usr/bin/xterm

# Needed for light
sudo usermod -aG video "$USER"

# Enable locking on suspend
sudo cp lock-on-suspend@.service /etc/systemd/system/
sudo systemctl enable lock-on-suspend@"$USER".service

# Enable OpenTabletDriver daemon
systemctl --user enable opentabletdriver.service --now

# Add login message
sudo cp issue /etc/issue

# Setup GNOME Keyring
sudo cp /etc/pam.d/login /etc/pam.d/login.bak
sudo cp pam_login /etc/pam.d/login

# Allow autorandr to run "systemctl suspend"
sudo cp 85-system-actions.rules /etc/polkit-1/rules.d/

# Set wireless regulatory domain
sudo cp wireless-regdom /etc/conf.d/wireless-regdom

# Disable network power saving
sudo cp powersave.conf /etc/NetworkManager/conf.d/powersave.conf

# Disable mouse acceleration
sudo cp 40-disable-accel.conf /etc/X11/xorg.conf.d/

# Setup root gtk theme
sudo mkdir -p /root/.config
sudo mkdir -p /root/.themes
sudo ln -sf ~/.config/gtk-3.0 /root/.config/gtk-3.0
sudo ln -sf ~/.config/gtk-4.0 /root/.config/gtk-4.0
sudo ln -sf ~/.themes/adw-gtk3-dark /root/.themes/adw-gtk3-dark
sudo ln -sf ~/.icons/oreo_white_cursors /usr/share/icons/oreo_white_cursors

# Disable loud beep
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
sudo modprobe -r pcspkr 2>/dev/null || true

# Setup gamemode
sudo usermod -aG gamemode "$USER"

# Use libsecret as the git credential helper
git config --global credential.helper libsecret

mkdir -p ~/Pictures/Screenshots
