#!/bin/env bash

PID=${1:-$$}
ECN=0

PID_deluge_W=$(pgrep 'deluge-web' | grep -v $PID)
PID_deluge_D=$(pgrep 'deluged' | grep -v $PID)
STOP_twonky_="$HOME/Programmi/twonky/twonky.sh stop"

printf '#%.0s' {1..120} ; echo

[ -n "$PID_deluge_W" ] && PSC_deluge_W=$(ps -efj | grep "$PID_deluge_W " | grep -v grep)
[ -n "$PID_deluge_D" ] && PSC_deluge_D=$(ps -efj | grep "$PID_deluge_D " | grep -v grep)

[ -n "$PID_deluge_W" ] && printf "# %5s = %s\n" "$PID_deluge_W" "$PSC_deluge_W"
[ -n "$PID_deluge_D" ] && printf "# %5s = %s\n" "$PID_deluge_D" "$PSC_deluge_D"

[ -n "$PID_deluge_W" ] && echo "kill $PID_deluge_W" && ECN=1
[ -n "$PID_deluge_D" ] && echo "kill $PID_deluge_D" && ECN=1

eval "$STOP_twonky_"

exit $ECN
