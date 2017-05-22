#!/bin/env bash

#CZ#OFF=${1:-false}
PID=${1:-$$}
ECN=0

TAG_peervpn='peervpn'
PID_peervpn=$(pgrep "$TAG_peervpn" | grep -v $PID)

printf '#%.0s' {1..120} ; echo

[ -n "$PID_peervpn" ] && PSC_peervpn=$(ps -efj | grep "$PID_peervpn " | grep -v grep)
[ -n "$PID_peervpn" ] && printf "# %5s = %s\n" "$PID_peervpn" "$PSC_peervpn"
[ -n "$PID_peervpn" ] && echo "kill $PID_peervpn" && ECN=1

#CZ#( $OFF ) && killall "$TAG_peervpn"

exit $ECN
