#!/bin/env bash

PID=${1:-$$}

PID_deluge_W=$(pgrep 'deluge-web' | grep -v $PID)
PID_deluge_D=$(pgrep 'deluged' | grep -v $PID)

[ -n "$PID_deluge_W" ] && PSC_deluge_W=$(ps -efj | grep "$PID_deluge_W " | grep -v grep)
[ -n "$PID_deluge_D" ] && PSC_deluge_D=$(ps -efj | grep "$PID_deluge_D " | grep -v grep)

[ -n "$PID_deluge_W" ] && printf "# %5s = %s\n" "$PID_deluge_W" "$PSC_deluge_W"
[ -n "$PID_deluge_D" ] && printf "# %5s = %s\n" "$PID_deluge_D" "$PSC_deluge_D"

[ -n "$PID_deluge_W" ] && echo "kill $PID_deluge_W"
[ -n "$PID_deluge_D" ] && echo "kill $PID_deluge_D"

exit
