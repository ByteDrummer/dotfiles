#!/bin/bash

# options to be displayed
option0="screen"
option1="area"
option2="window"

# options to be displyed
options="$option0\n$option1\n$option2"

selected="$(echo -e "$options" | rofi -lines 3 -dmenu -p "scrot" -theme-str 'window {width: 10%;}')"
case $selected in
    $option0)
        cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;;
    $option1)
        cd $(xdg-user-dir PICTURES)/ && scrot --select --line mode=edge ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;;
    $option2)
        cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot -u ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;;
esac

