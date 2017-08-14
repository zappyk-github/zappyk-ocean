#!/bin/env bash

N_REMOTE=${1} ; shift # [ -z "$N_REMOTE" ] && echo "$(basename "$0"): file/directory remote?" && exit 1
D_LOCAL_=${1:-.}

N_REMOTE=$(printf '%q' "$N_REMOTE")
H_REMOTE='zappyk-rp1'
D_REMOTE='/home/zappyk/Programmi/deluge/var/incomings'
F_REMOTE="$H_REMOTE:$D_REMOTE/$N_REMOTE"

SCP_OPTS=""
SCP_OPTS="$SCP_OPTS -r"
SCP_OPTS="$SCP_OPTS -l 100000" # 100000 kilobit => 12,5 Megabyte

SCP_CMMD="scp $SCP_OPTS \"$F_REMOTE\" \"$D_LOCAL_\""

echo "$SCP_CMMD"
eval "$SCP_CMMD"

exit
