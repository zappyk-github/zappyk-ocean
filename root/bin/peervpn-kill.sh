#!/bin/env bash

THIS=$(basename "$0")
THIS=${THIS/-kill/}

#TAG=${1:-peervpn}
TAG=${1:-$THIS}
OFF=${2:-false}
PID=${3:-$$}
ECN=0

TAG_peervpn=$TAG
PID_peervpn=$(pgrep -f "$TAG_peervpn" | grep -v $PID)

if [ -n "$PID_peervpn" ]; then

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
    [ $ECN -eq 0 ] && echo "Some peervpn is running (pid $PID_peervpn) but not $THIS!" && exit 1

#CZ#( $OFF ) && killall "$TAG_peervpn"

else
    echo "No $THIS is running!" && exit 1
fi

exit $ECN
