#!/bin/env bash

USER_NAME=$1
HOST_NAME=$2
_COMMAND_=''

SSH_HOST_NAME='sipert'
SSH_USER_NAME='pes0zap@'
#-------------+------------+
# HOSTs       | IP ADDRESS |
#-------------+------------+
# vls         | 10.0.3.5   |
# pls         | 10.0.3.6   |
# sls         | 10.0.3.7   |
# pdb         | 10.0.3.20  |
# eis         | 10.0.3.21  |
# test        | 10.0.3.22  |
# win01       | 10.0.3.23  |
# gestionale  | 10.0.3.99  |
#-------------+------------+

[ -n "$HOST_NAME" ] && SSH_HOST_NAME=$HOST_NAME

case "$SSH_HOST_NAME" in
    pls | vls  ) SSH_HOST_NAME='10.0.3.5' ;;
    sipert     ) SSH_HOST_NAME='10.0.3.64' ;;
    gestionale ) SSH_HOST_NAME='10.0.3.99' ;;
    *          ) echo -e "Usage:\n\t$(basename "$0") [ [ USER ] [ HOST ] ]\nHost '$SSH_HOST_NAME' non configurato..." && exit 1
esac

[ $(id -u) -eq 0  ] && SSH_USER_NAME='root@'
[ -n "$USER_NAME" ] && SSH_USER_NAME="$USER_NAME@"

_COMMAND_="ssh -X $SSH_USER_NAME$SSH_HOST_NAME"
_COMMAND_="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -X $SSH_USER_NAME$SSH_HOST_NAME"

echo "$_COMMAND_"
eval "$_COMMAND_"

exit
