#!/bin/bash

# Show commands
set -x

brew bundle install --file ~/Brewfile

yabai --start-service
skhd --start-service
brew services start sketchybar
brew services start borders
