#!/bin/env bash

# Dim powermenu button
polybar-msg action "#powermenu.hook.1"

# Options for powermenu
lock="Lock\0icon\x1fxfsm-lock"
logout="Logout\0icon\x1fxfsm-logout"
shutdown="Shutdown\0icon\x1fxfsm-shutdown"
reboot="Reboot\0icon\x1fxfsm-reboot"
suspend="Suspend\0icon\x1fxfsm-suspend"

# Get answer from user via rofi
selected=$(echo -en "$lock
$logout
$suspend
$reboot
$shutdown" | rofi -dmenu\
                  -i\
                  -p "Power"\
                  -lines 5\
                  -theme-str 'window {width: 160px;
                                      location: northwest;
                                      x-offset: 5%;}')

# Do something based on selected option
if [ $selected != "\n" ]; then
  if [[ $lock =~ $selected ]]; then
      betterlockscreen -l dimblur
  elif [[ $logout =~ $selected ]]; then
      bspc quit
  elif [[ $shutdown =~ $selected ]]; then
      systemctl poweroff
  elif [[ $reboot =~ $selected ]]; then
      systemctl reboot
  elif [[ $suspend =~ $selected ]]; then
      systemctl suspend
  fi
fi

# Undim powermenu button
polybar-msg action "#powermenu.hook.0"
