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
yay -S blueman gthumb arandr playerctl betterlockscreen caffeine-ng xidlehook light autorandr kvantum qt5ct qt6ct

# Needed for light
sudo usermod -aG video $USER

# Enable locking on suspend
sudo cp ~/.config/systemd_unit_files/lock-on-suspend@.service /etc/systemd/system/
sudo systemctl enable lock-on-suspend@$(whoami).service

# Disable the display manager
sudo rm /etc/systemd/system/display-manager.service

# Add login message
sudo cp ~/.config/wired /etc/issue

# Setup Wacom tablet
yay -S xf86-input-wacom
sudo cp ~/.config/wacom/99-wacom.rules /etc/udev/rules.d/
systemctl --user enable --now wacom.service

# Disable minimize, maximize, and close buttons
gsettings set org.gnome.desktop.wm.preferences button-layout :

# Setup gtk theme
yay -S adw-gtk3
wget https://github.com/lonr/adwaita-one-dark/releases/download/v0.44.0/Adwaita-One-Dark.tar.xz -P ~/Downloads/
mkdir ~/.local/share/themes/Adwaita-One-Dark
tar -xf ~/Downloads/Adwaita-One-Dark.tar.xz -C ~/.local/share/themes/Adwaita-One-Dark/
ln -s ~/.local/share/themes/Adwaita-One-Dark/colors/gtk-dark.css ~/.config/gtk-4.0/gtk.css
ln -s ~/.local/share/themes/Adwaita-One-Dark/colors/gtk-dark.css ~/.config/gtk-3.0/gtk.css
mkdir -p ~/.themes/adw-gtk3-dark
ln -s ~/.local/share/themes/Adwaita-One-Dark/gtk-2.0 ~/.themes/adw-gtk3-dark/gtk-2.0
sudo ln -s ~/.config/gtk-3.0 /root/.config/gtk-3.0


# Disable loud system beep
sudo sh -c 'rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf'

mkdir ~/Pictures/Screenshots
