#!/bin/sh
if [[ "$1" != "Spotify" &&
      "$1" != "discord" &&
      "$1" != "Thunderbird" ]]; then
  paplay ~/.config/dunst/notification.ogg
fi
