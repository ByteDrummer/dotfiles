#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

monitors="$(xrandr | grep " connected")"

# Reorder list so icon tray attaches to the bar for the primary monitor
if echo "$monitors" | grep -q "primary"; then
  temp="$monitors"
  monitors="$(echo "$temp" | grep "primary")"
  monitors+=$'\n'
  monitors+="$(echo "$temp" | grep -v "primary")"
fi

for MONITOR in $(echo "$monitors" | cut -d" " -f1); do
  source "$(dirname "$0")/calculate_bar_offset.sh"
  MONITOR=$MONITOR BAR_OFFSET=$BAR_OFFSET WM_NAME="polybar-${MONITOR}" polybar --reload top &
  sleep 0.3
done
