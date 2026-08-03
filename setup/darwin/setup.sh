#!/bin/bash

# Show commands
set -x

# Stop script on error
set -e

# Install all required packages
brew bundle install --file Brewfile

# Enable window manager
yabai --start-service
skhd --start-service
brew services start sketchybar
brew services start borders

# Install zsh plugins
sheldon lock
