#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
if type "xrandr"; then
  monitors="$(xrandr --query | grep " connected")"

  # Reorder list so icon tray attaches to the bar for the primary monitor
  if echo "$monitors" | grep "primary"; then
    temp="$monitors"
    monitors="$(echo "$temp" | grep "primary")"
    monitors+=$'\n'
    monitors+="$(echo "$temp" | grep -v "primary")"
  fi

  for m in $(echo "$monitors" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
    sleep 0.3
  done
else
  polybar --reload top &
fi
