#!/bin/sh

# The script will be called as follows:
#   script appname summary body icon urgency

if [[ "$1" != "Spotify" &&
      "$1" != "discord" &&
      "$1" != "Slack" &&
      "$1" != "Thunderbird" &&
      "$3" != *"calendar.google.com"* ]]; then
  paplay ~/.config/dunst/notification.ogg
fi
