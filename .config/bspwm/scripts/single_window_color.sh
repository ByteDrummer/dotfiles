#!/bin/env bash

bspc subscribe desktop_layout desktop_focus node_add node_remove node_stack node_focus | while read -a line; do
  count=$(bspc query -N -d focused -n .window.\!hidden | wc -l)
  echo $count
  if [ $count == 1 ]; then
    bspc config focused_border_color "#282c34"
  else
    bspc config focused_border_color "#61afef"
  fi
done
