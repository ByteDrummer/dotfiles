#!/bin/bash

set -x

# update system
sudo pacman -Syu

# Install git
sudo pacman -S git base-devel

# Switch shell
chsh -s $(which zsh)

# Install p10k
paru -S zsh-theme-powerlevel10k-git

# Install nodejs and npm for Coc
sudo pacman -S nodejs npm

# Install Markdown viewer dependencies
sudo npm -g install instant-markdown-d

# Install Java
sudo pacman -S jre-openjdk
sudo pacman -S jdk-openjdk

# Install recommended font for p10k
mkdir ~.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/.fonts

# Install LaTeX
# sudo pacman -S texlive-most

# Install neovim
sudo pacman -S xclip # for copy paste support
sudo pacman -S neovim
sudo pacman -S python-pip
python3 -m pip install --user --upgrade pynvim

# Install vim-plug and plugins
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --clean '+source ~/.config/nvim/init.vim' +PlugInstall +qall

# Install coc extensions
nvim +'CocInstall -sync coc-explorer coc-snippets coc-marketplace coc-tsserver coc-eslint coc-sql coc-html coc-json coc-java coc-clangd coc-pyright coc-sh coc-vimtex' +qall

# Install python modules for coc-pyright
pip install rope
pip install autopep8
pip install flake8

# Install terminal one-dark theme
bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh)"

echo 'PY NOTE: YOU WILL NEED TO INSTALL pynvim AND OTHER NECESSARY PACKAGES IN YOUR VENV'
echo 'JS NOTE: MAKE SURE TO SET UP ESLINT FOR YOUR PROJECT WITH "npx eslint --init" AFTER APPROVING IT INSIDE OF VIM'
