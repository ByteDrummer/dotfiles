#!/usr/bin/env bash

# Workaround for electron and chrome window focusing bug
# See link for more info: https://github.com/baskerville/bspwm/issues/811
# Make sure to turn off hardware acceleration in chrome for proper refocusing

get_class_wids() {
    for wid in ${!wid_to_class[@]}; do
	if grep -qi "$*" <<< "${wid_to_class[$wid]}" ; then
	    echo "$wid"
	fi
    done
}

set_state() {
    for wid in $(get_class_wids "$*"); do
	# if wid is not in our dtop, hide it (attempt to force unfocus)
	if bspc query -N -d .active -n $wid >/dev/null; then
	    echo "$*: showing!"
	    bspc node $wid -g hidden=false
	else
	    echo "$*: hiding!"
	    bspc node $wid -g hidden=true
	fi
    done
}

declare -A wid_to_class=();
act() {
    # cache
    wid_to_class=();
    for wid in $(bspc query -N -n .window); do
	wid_to_class[$wid]=$(xprop WM_CLASS -id "$wid")
    done

    # NB: add cases here:
    set_state google-chrome
    set_state discord
    set_state slack
}

act

while read -r event mon_id desk_id; do
    act

    # fix refocus issue by using xqp: https://github.com/baskerville/xqp
    # if $(bspc config focus_follows_pointer); then
    # 	bspc node -f $(xqp)
    # fi
done < <(bspc subscribe desktop_focus)
