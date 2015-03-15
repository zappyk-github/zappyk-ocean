#!/bin/env bash

HOST_NAME=$1
USER_NAME=$2
_COMMAND_=''

#--------+------------+
# HOSTs  | IP ADDRESS |
#--------+------------+
# vls    | 10.0.3.5   |
# pls    | 10.0.3.6   |
# sls    | 10.0.3.7   |
# pdb    | 10.0.3.20  |
# eis    | 10.0.3.21  |
# test   | 10.0.3.22  |
# win01  | 10.0.3.23  |
#--------+------------+
HOST_NAME='sipert'
USER_NAME='pes0zap'
case "$HOST_NAME" in
    pls | vls ) HOST_NAME='10.0.3.5' ;;
    sipert    ) HOST_NAME='10.0.3.64' ;;
    *         ) echo "Usage:\n\t$(basename "$0") [ [ HOST ] [ USER ] ]\nHost '$HOST_NAME' non configurato..." && exit 1
esac

[ $(id -u) -eq 0  ] && USER_NAME='root'
[ -n "$USER_NAME" ] && USER_NAME="$USER_NAME@"

_COMMAND_="ssh -X $USER_NAME$HOST_NAME"

echo "$_COMMAND_"
eval "$_COMMAND_"

exit
