#!/bin/env bash

PID=${1:-$$}
ECN=0

PID_deluge_W=$(pgrep 'deluge-web' | grep -v $PID)
PID_deluge_D=$(pgrep 'deluged' | grep -v $PID)

PATH_twonky_="$HOME"
PATH_twonky_="/home/zappyk"
EVAL_twonky_="$PATH_twonky_/Programmi/twonky/twonky.sh"
STOP_twonky_="$EVAL_twonky_ stop"

PATH_plexms_="$HOME"
PATH_plexms_="/home/zappyk"
EVAL_plexms_="$PATH_plexms_/Programmi/plex/plex.sh"
STOP_plexms_="$EVAL_plexms_ stop"

printf '#%.0s' {1..120} ; echo

[ -n "$PID_deluge_W" ] && PSC_deluge_W=$(ps -efj | grep "$PID_deluge_W " | grep -v grep)
[ -n "$PID_deluge_D" ] && PSC_deluge_D=$(ps -efj | grep "$PID_deluge_D " | grep -v grep)

[ -n "$PID_deluge_W" ] && printf "# %5s = %s\n" "$PID_deluge_W" "$PSC_deluge_W"
[ -n "$PID_deluge_D" ] && printf "# %5s = %s\n" "$PID_deluge_D" "$PSC_deluge_D"

[ -n "$PID_deluge_W" ] && echo "kill $PID_deluge_W" && ECN=1
[ -n "$PID_deluge_D" ] && echo "kill $PID_deluge_D" && ECN=1

[ -x "$EVAL_twonky_" ] && eval "$STOP_twonky_"
[ -x "$EVAL_plexms_" ] && eval "$STOP_plexms_"

exit $ECN
