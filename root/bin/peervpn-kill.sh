#!/bin/env bash

THIS=$(basename "$0")

OFF=${1:-false}
TAG=${2:-peervpn}
PID=${3:-$$}
ECN=0

TAG_peervpn=$TAG
PID_peervpn=$(pgrep -f "$TAG_peervpn" | grep -v $PID)

first=true

for PID_find in $PID_peervpn; do
    PSC_peervpn=$(ps -efj | grep "$PID_find " | grep -v grep)
    if [ -n "$PSC_peervpn" ]; then
	( $first ) && first=false && \
        printf '#%.0s' {1..120} && echo
        printf "# %5s = %s\n" "$PID_find" "$PSC_peervpn"
        echo "kill $PID_find"
        ECN=1
    fi
done

#CZ#( $OFF ) && killall "$TAG_peervpn"

exit $ECN
