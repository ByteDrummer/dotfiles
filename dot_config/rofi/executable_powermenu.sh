#!/bin/env bash

source "$(dirname "$0")/get_bar_offset.sh"

# Dim powermenu button
polybar-msg action "#powermenu.hook.1"

lock="Lock\0icon\x1fxfsm-lock"
logout="Logout\0icon\x1fxfsm-logout"
shutdown="Shutdown\0icon\x1fxfsm-shutdown"
reboot="Reboot\0icon\x1fxfsm-reboot"
suspend="Suspend\0icon\x1fxfsm-suspend"
hibernate="Hibernate\0icon\x1fxfsm-hibernate"

options="$lock\n$logout\n$suspend\n$hibernate\n$reboot\n$shutdown"

# Get answer from user via rofi
selected=$(
  echo -en "$options" | 
  rofi -dmenu -i -p "Power" -lines 5 -theme-str \
    "window {width: 160px; location: northwest; x-offset: ${X_OFFSET};}"
)

# Do something based on selected option
if [ "$selected" != "" ]; then
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
  elif [[ $hibernate =~ $selected ]]; then
    systemctl hibernate
  fi
fi

# Undim powermenu button
polybar-msg action "#powermenu.hook.0"
