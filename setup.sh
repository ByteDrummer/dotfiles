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

# Install recommended font for p10k
yay -S ttf-meslo-nerd-font-powerlevel10k

# Install vim-plug
yay -S neovim-plug

# Install Alacritty
sudo pacman -S alacritty
yay -S nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# Remove gnome-terminal from nautilus menu
sudo mv -vi /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}
nautilus -q

# Install tmux
sudo pacman -S tmux
