#!/bin/bash

source "$(dirname "$0")/get_bar_offset.sh"

screen="Screen\0icon\x1f/usr/share/icons/Papirus-Dark/16x16/devices/computer.svg"
area="Area\0icon\x1fimage-crop"
window="Window\0icon\x1fwindow"

options="$screen\n$area\n$window"

selected=$(
  echo -en "$options" | 
  rofi -i lines 3 -dmenu -p "Scrot" -theme-str \
    "window {width: 140px; location: northeast; x-offset: -${X_OFFSET};}"
)

if [ $selected != "\n" ]; then
  if [[ $screen =~ $selected ]]; then
    cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
  elif [[ $area =~ $selected ]]; then
    cd $(xdg-user-dir PICTURES)/ && scrot -f -s ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
  elif [[ $window =~ $selected ]]; then
    cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot -u ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
  fi
fi
