#!/bin/bash

# Show commands
set -x

# Stop script on error
set -e

brew bundle install --file Brewfile

yabai --start-service
skhd --start-service
brew services start sketchybar
brew services start borders
