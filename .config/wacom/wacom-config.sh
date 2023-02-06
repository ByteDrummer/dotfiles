#!/bin/sh

scale=1

if [[ ! -z $1 ]]; then
  scale=$1
fi

for i in $(seq 10); do
    if xsetwacom list devices | grep -q Wacom; then
        break
    fi
    sleep 1
done

sudo modprobe -r wacom; sudo modprobe wacom; sleep 0.5 # reset tablet settings

primary_monitor=$(xrandr | grep primary | sed 's/ .*//')
list=$(xsetwacom list devices)
stylus=$(echo "${list}" | grep stylus | sed 's/\s*id.*//')
tablet_width=$(xsetwacom get "$stylus" Area | cut -d " " -f 3)
tablet_width=$(perl -e "print int($tablet_width * $scale + 0.5)")
tablet_height=$(xsetwacom get "$stylus" Area | cut -d " " -f 4)
tablet_height=$(perl -e "print int($tablet_height * $scale + 0.5)")
tablet_ratio=$(perl -e "print $tablet_width / $tablet_height")
screen_dim=$(xrandr | grep "connected primary" | cut -d " " -f 4)
screen_width=$(echo "$screen_dim" | sed 's/x.*//')
screen_height=$(echo "$screen_dim" | sed 's/.*x\(.*\)+.*+.*/\1/')
screen_ratio=$(perl -e "print $screen_width / $screen_height")

xsetwacom set "$stylus" MapToOutput "$primary_monitor"

if [[ $tablet_ratio < $screen_ratio ]]; then # if tablet is thinner
  area_height=$(perl -e "print int($tablet_width / $screen_ratio + 0.5)")
  xsetwacom set "$stylus" Area 0 0 $tablet_width $area_height
else # if tablet is wider
  area_width=$(perl -e "print int($tablet_height * $screen_ratio + 0.5)")
  xsetwacom set "$stylus" Area 0 0 $area_width $tablet_height
fi
