#!/bin/env bash

N_REMOTE=${1}; shift; [ -z "$N_REMOTE" ] && echo "$(basename "$0"): file remote?" && exit 1
O_LOCAL_=${*}

#N_REMOTE=$(printf '%q' "$N_REMOTE")
H_REMOTE='zappyk-rp1'
D_REMOTE='/incomings'
F_REMOTE="http://$H_REMOTE$D_REMOTE/$N_REMOTE"

WGETOPTS=""
WGETOPTS="$WGETOPTS --continue"
WGETOPTS="$WGETOPTS --limit-rate=20m" # 20m => 20 Megabyte

WGETCMMD="wget $WGETOPTS \"$F_REMOTE\" $O_LOCAL_"

echo "$WGETCMMD"
eval "$WGETCMMD"

exit
