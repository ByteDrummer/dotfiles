#!/usr/bin/env bash

# Workaround for electron and chromium window focusing bug
# See link for more info: https://github.com/baskerville/bspwm/issues/811

# include problematic window class names here (case insensitive)
classes=("chromium" "discord" "slack")

bspc subscribe desktop_focus node_transfer | while read -r _; do
  #echo "Desktop changed -------"

  # iterate over all window IDs
  for wid in $(bspc query -N -n .window); do
    wm_class="$(xprop WM_CLASS -id "$wid")"

    # check if WM_CLASS matches any of the class names
    for class in "${classes[@]}"; do
      if grep -qi "$class" <<< "$wm_class" ; then
        # hide or unhide the given window
        if bspc query -N -d .active -n "$wid">/dev/null; then
          #echo "$class: showing"
          bspc node "$wid" -g hidden=false
        else
          #echo "$class: hiding"
          bspc node "$wid" -g hidden=true
        fi

        break
      fi
    done
  done

  # make sure the currently focused desktop becomes the previously focused
  # desktop when switching
  bspc desktop --focus
done
