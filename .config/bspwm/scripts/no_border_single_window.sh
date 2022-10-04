#!/bin/env bash

bspc subscribe desktop_layout desktop_focus node_add node_remove node_stack node_focus | while read -a line; do
  count=$(bspc query -N -d focused -n .window.\!hidden | wc -l)
  echo $count
  if [ $count == 1 ]; then
    bspc config border_width 0
  else
    bspc config border_width 2
  fi
done
