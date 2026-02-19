#!/bin/bash

primary_monitor=$(xrandr | grep primary | sed 's/ .*//')

bspc rule -a Geary desktop="$primary_monitor:^1"
bspc rule -a "*:calendar.google.com" desktop="$primary_monitor:^1"
bspc rule -a "*:messages.google.com" desktop="$primary_monitor:^2"
bspc rule -a discord desktop="$primary_monitor:^2"
bspc rule -a Slack desktop="$primary_monitor:^2"
bspc rule -a Lutris desktop="$primary_monitor:^5"
bspc rule -a steam desktop="$primary_monitor:^5"
