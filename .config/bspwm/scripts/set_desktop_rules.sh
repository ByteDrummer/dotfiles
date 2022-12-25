#!/bin/bash

monitor=""

if [ "$1" = "duplicate" ]; then
  monitor="$(bspc query -M --names)"
else
  monitor="$(xrandr | grep primary | sed 's/ .*//')"
fi

bspc rule -a thunderbird desktop="$monitor:^1"
bspc rule -a "*:crx_kjbdgfilnfhdoflbpgamdcdgpehopbep" desktop="$monitor:^1"
bspc rule -a "*:crx_mgamiaabcidhdjkgbmmalofnegcnbbpi" desktop="$monitor:^2"
bspc rule -a discord desktop="$monitor:^2"
bspc rule -a Lutris desktop="$monitor:^5"
bspc rule -a Steam desktop="$monitor:^5"
