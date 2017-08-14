#!/bin/env bash

N_REMOTE=${1} ; shift # [ -z "$N_REMOTE" ] && echo "$(basename "$0"): file/directory remote?" && exit 1
O_LOCAL_=${*}

################################################################################
# NOTE : if $N_REMOTE is a directory, don't forget char '/' at the end of name !
lastchar=${N_REMOTE:$((${#N_REMOTE}-1)):1}
if [ "$lastchar" != '/' ]; then
    read -p "Remote \"$N_REMOTE\" is a directory? [s/N] " answer
    [[ "$answer" =~ [sS] ]] && N_REMOTE="$N_REMOTE/"
fi
################################################################################

#N_REMOTE=$(printf '%q' "$N_REMOTE")
H_REMOTE='zappyk-rp1'
D_REMOTE='/incomings'
F_REMOTE="http://$H_REMOTE$D_REMOTE/$N_REMOTE"

WGETOPTS=""
WGETOPTS="$WGETOPTS --continue"
WGETOPTS="$WGETOPTS --limit-rate=20m" # 20m => 20 Megabyte
#-------= addiction options for directory
WGETOPTS="$WGETOPTS --recursive --cut-dirs=1"
WGETOPTS="$WGETOPTS --no-host-directories --no-parent"
WGETOPTS="$WGETOPTS --execute robots=off"
WGETOPTS="$WGETOPTS --reject \"index*\""

WGETCMMD="wget $WGETOPTS \"$F_REMOTE\" $O_LOCAL_"

echo "$WGETCMMD"
eval "$WGETCMMD"

exit
