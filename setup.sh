#!/bin/bash

set -x # show commands

# update system
sudo pacman -Syu

# Install AUR helper
sudo pacman -S yay

# Install git
sudo pacman -S git base-devel

# Switch shell
chsh -s $(which zsh)

# Install zsh plugins
sudo pacman -S zsh-theme-powerlevel10k zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search

# Install nodejs and npm for CoC
sudo pacman -S nodejs npm

# Install Java
sudo pacman -S jre-openjdk
sudo pacman -S jdk-openjdk

# Install recommended font for p10k
mkdir ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/.fonts

# Install neovim
sudo pacman -S xclip # for copy paste support
yay -S neovim-nightly-bin

# Install python modules for coc-pyright
sudo pacman -S python-pip
pip install pynvim
pip install rope
pip install autopep8
pip install flake8
# IN VENV: pip install pynvim rope autopep8 flake8

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install Alacritty
sudo pacman -S alacritty
yay -S nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# Remove gnome-terminal from nautilus menu
sudo mv -vi /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}
nautilus -q

# Install tmux
sudo pacman -S tmux

echo 'PY NOTE: YOU WILL NEED TO INSTALL pynvim AND OTHER NECESSARY PACKAGES IN YOUR VENV'
echo 'JS NOTE: MAKE SURE TO SET UP ESLINT FOR YOUR PROJECT WITH "npx eslint --init" AFTER APPROVING IT INSIDE OF VIM'
