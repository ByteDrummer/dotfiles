#!/bin/bash

# options to be displayed
option0="Screen\0icon\x1f/usr/share/icons/Papirus-Dark/16x16/devices/computer.svg"
option1="Area\0icon\x1fimage-crop"
option2="Window\0icon\x1fwindow"

# options to be displyed
options="$option0\n$option1\n$option2"

selected=$(echo -en "$options" | rofi -i lines 3 -dmenu -p "Scrot" -theme-str 'window {width: 140px;
                                                                                        location: northeast;
                                                                                        x-offset: -5%;}')

if [ $selected != "\n" ]; then
  if [[ $option0 =~ $selected ]]; then
    cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
  elif [[ $option1 =~ $selected ]]; then
    cd $(xdg-user-dir PICTURES)/ && scrot --select --line mode=edge ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
  elif [[ $option2 =~ $selected ]]; then
    cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot -u ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png
  fi
fi
