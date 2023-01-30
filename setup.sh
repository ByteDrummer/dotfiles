#!/bin/bash

set -x # show commands

# update system
sudo pacman -Syu

# Install AUR helper
sudo pacman -S yay

# Install git
sudo pacman -S git

# Install zsh and switch shell
sudo pacman -S zsh
chsh -s $(which zsh)

# Install zsh plugin manager
yay -S antigen-git

# Install pip
sudo pacman -S python-pip

# Install nodejs and npm
sudo pacman -S nodejs npm

# Install Java
sudo pacman -S jre-openjdk jdk-openjdk

# Install neovim
sudo pacman -S xclip neovim # xclip is for copy paste support

# Install terminal fonts
yay -S ttf-meslo-nerd-font-powerlevel10k ttf-hack-nerd

# Install Alacritty
sudo pacman -S alacritty
yay -S nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# Install tmux
sudo pacman -S tmux

# Install vivid to generate LS_COLORS
sudo pacman -S vivid

# Install additional desktop software
yay -S blueman gthumb arandr playerctl betterlockscreen caffeine-ng xidlehook light autorandr kvantum

# Needed for light
sudo usermod -aG video $USER

# Enable locking on suspend
sudo cp ~/.config/systemd_unit_files/lock-on-suspend@.service /etc/systemd/system/
sudo systemctl enable lock-on-suspend@$(whoami).service

# Disable the display manager
sudo rm /etc/systemd/system/display-manager.service

# Add login message
sudo cp ~/.config/wired /etc/issue

# Disable minimize, maximize, and close buttons
gsettings set org.gnome.desktop.wm.preferences button-layout :

# Disable loud system beep
sudo sh -c 'rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf'

mkdir ~/Pictures/Screenshots
