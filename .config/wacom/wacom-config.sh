#!/bin/sh

for i in $(seq 10); do
    if xsetwacom list devices | grep -q Wacom; then
        break
    fi
    sleep 1
done

primary_monitor=$(xrandr | grep primary | sed 's/ .*//')
list=$(xsetwacom list devices)
stylus=$(echo "${list}" | grep stylus | sed 's/\s*id.*//')
tablet_width=$(xsetwacom get "$stylus" Area | cut -d " " -f 3)
screen_dim=$(xrandr | grep "connected primary" | cut -d " " -f 4)
screen_width=$(echo "$screen_dim" | sed 's/x.*//')
screen_height=$(echo "$screen_dim" | sed 's/.*x\(.*\)+.*+.*/\1/')
tablet_height=$(perl -e "print $tablet_width * $screen_height / $screen_width")

xsetwacom set "$stylus" MapToOutput "$primary_monitor"
xsetwacom set "$stylus" Area 0 0 $tablet_width $tablet_height
