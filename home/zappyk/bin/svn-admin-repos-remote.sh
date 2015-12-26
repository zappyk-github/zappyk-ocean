#!/bin/env bash

THISHOSTNAME=$(hostname -f)
REMOTE_HOSTS='zappyk-ws zappyk-mc zappyk-zb zappyk-nb'

REMOTE_USERS=$USER
REMOTE_CMMDS="source .bash_profile ; svn-admin-repos.sh $*"

for remote_host in $REMOTE_HOSTS; do
    [ "$THISHOSTNAME" == "$remote_host" ] && continue
    remote_user="$REMOTE_USERS@$remote_host"
    remote_cmmd="ssh $remote_user \"$REMOTE_CMMDS\""
    echo "${remote_cmmd//?/_}"
    echo "${remote_cmmd}"
    eval "${remote_cmmd}" | sed "s/^/$remote_user| /g"
done

exit
