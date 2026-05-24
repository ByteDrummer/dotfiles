#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr" >/dev/null 2>&1; then
  monitors="$(xrandr | grep " connected")"

  # Reorder list so icon tray attaches to the bar for the primary monitor
  if echo "$monitors" | grep -q "primary"; then
    temp="$monitors"
    monitors="$(echo "$temp" | grep "primary")"
    monitors+=$'\n'
    monitors+="$(echo "$temp" | grep -v "primary")"
  fi

  for MONITOR in $(echo "$monitors" | cut -d" " -f1); do
    source "$(dirname "$0")/get_bar_geometry.sh"
    MONITOR=$MONITOR BAR_WIDTH=$BAR_WIDTH BAR_OFFSET=$BAR_OFFSET polybar --reload top &
    sleep 0.3
  done
else
  # Fallback if xrandr isn't available
  BAR_WIDTH="90%" BAR_OFFSET="10%" polybar --reload top &
fi
