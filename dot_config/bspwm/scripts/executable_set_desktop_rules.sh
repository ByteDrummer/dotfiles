#!/bin/bash

primary_monitor=$(xrandr | grep primary | sed 's/ .*//')

bspc rule -a org.mozilla.Thunderbird desktop="$primary_monitor:^1"
bspc rule -a "*:crx_kjbdgfilnfhdoflbpgamdcdgpehopbep" desktop="$primary_monitor:^1"
bspc rule -a "*:crx_hpfldicfbfomlpcikngkocigghgafkph" desktop="$primary_monitor:^2"
bspc rule -a discord desktop="$primary_monitor:^2"
bspc rule -a Slack desktop="$primary_monitor:^2"
bspc rule -a Lutris desktop="$primary_monitor:^5"
bspc rule -a steam desktop="$primary_monitor:^5"
