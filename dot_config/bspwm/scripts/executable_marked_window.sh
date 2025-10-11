#!/bin/env bash

while bspc subscribe -c 1 node_flag > /dev/null; do
    bspc config border_width 0

    bspc query -N -n '.marked.window' | while read -r wid; do
      bspc config -n $wid border_width 3
    done
done
