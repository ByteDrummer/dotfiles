#!/bin/env bash

# Options for powermenu
lock="Lock"
logout="Logout"
shutdown="Shutdown"
reboot="Reboot"
sleep="Sleep"

# Get answer from user via rofi
selected_option=$(echo "$lock
$logout
$sleep
$reboot
$shutdown" | rofi -dmenu\
                  -i\
                  -p "Power"\
                  -lines 5\
                  -theme-str 'configuration{show-icons: false;}
                              window {width: 180px;
                                      location: northwest;
                                      x-offset: 5%;}')

# Do something based on selected option
if [ "$selected_option" == "$lock" ]
then
    betterlockscreen -l dimblur
elif [ "$selected_option" == "$logout" ]
then
    bspc quit
elif [ "$selected_option" == "$shutdown" ]
then
    systemctl poweroff
elif [ "$selected_option" == "$reboot" ]
then
    systemctl reboot
elif [ "$selected_option" == "$sleep" ]
then
    amixer set Master mute
    systemctl suspend
else
    echo "No match"
fi
