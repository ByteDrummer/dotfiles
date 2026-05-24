#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR=$(xrandr | grep "primary" | cut -d" " -f1) 
source "$(dirname "$0")/get_bar_geometry.sh"

MONITOR=$MONITOR BAR_WIDTH=$BAR_WIDTH BAR_OFFSET=$BAR_OFFSET WM_NAME="polybar-${MONITOR}" polybar --reload top &
