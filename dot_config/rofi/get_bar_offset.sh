#!/usr/bin/env bash

MONITOR=$(bspc query -M -m focused --names)
X_OFFSET=$(xwininfo -name "polybar-$MONITOR" | awk '/Absolute upper-left X:/ {print $4}')px
