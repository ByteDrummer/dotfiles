#!/usr/bin/env bash

u=$(xprop -name "Polybar tray window" _NET_WM_PID 2> /dev/null | grep -o '[[:digit:]]*')

if [ "$1" == "-t" ]; then
  if [ "$u" != "" ]; then
    kill $u
  else
    polybar tray
  fi
elif [ "$1" == "-q" ]; then
  if [ "$u" != "" ]; then
    echo "%{T1}%{T-}"
  else
    echo "%{T1}%{T-}"
  fi
fi
