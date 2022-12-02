#!/bin/bash

# options to be displayed
option0=" Screen"
option1=" Area"
option2=" Window"

# options to be displyed
options="$option0\n$option1\n$option2"

selected="$(echo -e "$options" | rofi -i -lines 3 -dmenu -p "Scrot" -theme-str 'configuration{show-icons: false;}
                                                                                window {width: 140px;
                                                                                        location: northeast;
                                                                                        x-offset: -5%;}')"
case $selected in
    $option0)
        cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;;
    $option1)
        cd $(xdg-user-dir PICTURES)/ && scrot --select --line mode=edge ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;;
    $option2)
        cd $(xdg-user-dir PICTURES)/ && sleep 1 && scrot -u ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;;
esac

