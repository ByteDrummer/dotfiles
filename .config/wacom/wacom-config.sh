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
max_width=$(xsetwacom get "$stylus" Area | cut -d " " -f 3)
max_height=$(xsetwacom get "$stylus" Area | cut -d " " -f 4)
scaled_width=$(perl -e "print int($max_width * $scale + 0.5)")
scaled_height=$(perl -e "print int($max_height * $scale + 0.5)")
tablet_ratio=$(perl -e "print $scaled_width / $scaled_height")
screen_dim=$(xrandr | grep "connected primary" | cut -d " " -f 4)
screen_width=$(echo "$screen_dim" | sed 's/x.*//')
screen_height=$(echo "$screen_dim" | sed 's/.*x\(.*\)+.*+.*/\1/')
screen_ratio=$(perl -e "print $screen_width / $screen_height")
x=""
y=""

if [[ $tablet_ratio < $screen_ratio ]]; then # if tablet is thinner
  area_height=$(perl -e "print int($scaled_width / $screen_ratio + 0.5)")
  x=$(($max_width - $scaled_width))
  y=$(($max_height - $area_height))
else # if tablet is wider
  area_width=$(perl -e "print int($scaled_height * $screen_ratio + 0.5)")
  x=$(($max_width - $area_width))
  y=$(($max_height - $scaled_height))
fi

xsetwacom set "$stylus" MapToOutput "$primary_monitor"
xsetwacom set "$stylus" Area $x $y $max_width $max_height
