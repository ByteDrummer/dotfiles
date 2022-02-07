#!/bin/bash

set -x

# update system
sudo pacman -Syu

# Install git
sudo pacman -S git base-devel

# Switch shell
chsh -s $(which zsh)

# Install zsh plugins
paru -S zsh-theme-powerlevel10k-git
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions

# Install nodejs and npm for Coc
sudo pacman -S nodejs npm

# Install Markdown viewer dependencies
sudo npm -g install instant-markdown-d

# Install Java
sudo pacman -S jre-openjdk
sudo pacman -S jdk-openjdk

# Install recommended font for p10k
mkdir ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/.fonts

# Install LaTeX
sudo pacman -S texlive-most
paru -S texlive-latexindent-meta # install dependencies for latexindent

# Install neovim
sudo pacman -S xclip # for copy paste support
paru -S neovim-nightly-bin
sudo pacman -S python-pip

# Install python modules for coc-pyright
pip install pynvim
pip install rope
pip install autopep8
pip install flake8

# pip install pynvim rope autopep8 flake8

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install Alacritty
sudo pacman -S alacritty
paru -S nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
gsettings set org.gnome.desktop.default-applications.terminal exec

# Install tmux
sudo pacman -S tmux

echo 'PY NOTE: YOU WILL NEED TO INSTALL pynvim AND OTHER NECESSARY PACKAGES IN YOUR VENV'
echo 'JS NOTE: MAKE SURE TO SET UP ESLINT FOR YOUR PROJECT WITH "npx eslint --init" AFTER APPROVING IT INSIDE OF VIM'
