#!/bin/bash

bar_width=$(cat "$(dirname "$0")/config.ini" | grep "width" | 
  awk -F '=' '{print $2}' | tr -d ' ')
monitor_width=$(xrandr | grep "${MONITOR}" | grep -oP -m 1 '[0-9]+(?=x[0-9]+)')
# Safety fallback just in case a monitor is connected but inactive
monitor_width=${monitor_width:-0}
BAR_OFFSET=$(((monitor_width - bar_width) / 2))
