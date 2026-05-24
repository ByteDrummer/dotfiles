#!/bin/bash

width_px=$(xrandr | grep "${MONITOR}" | grep -oP -m 1 '[0-9]+(?=x[0-9]+)')

# Safety fallback just in case a monitor is connected but inactive
width_px=${width_px:-0}

# Set width percentage based on pixel width
if [ "$width_px" -ge 3440 ]; then
  BAR_WIDTH=50
elif [ "$width_px" -ge 2560 ]; then
  BAR_WIDTH=60
else
  BAR_WIDTH=90
fi

BAR_OFFSET="$(( (100 - BAR_WIDTH) / 2 ))%"
BAR_WIDTH="${BAR_WIDTH}%"
