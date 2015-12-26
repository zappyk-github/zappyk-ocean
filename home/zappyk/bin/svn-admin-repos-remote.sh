#!/bin/env bash

REMOTE_HOSTS='zappyk-ws zappyk-mc zappyk-zb zappyk-nb'
THISHOSTNAME=$(hostname -f)

REMOTE_CMMDS="source .bash_profile ; svn-admin-repos.sh $*"
REMOTE_USERS=$USER

for remote_host in $REMOTE_HOSTS; do
    [ "$THISHOSTNAME" == "$remote_host" ] && continue

    remote_user="$REMOTE_USERS@$remote_host"
    remote_cmmd="ssh $remote_user \"$REMOTE_CMMDS\""

    remote_tags="$remote_user| "
    remote_leng="$remote_tags$remote_cmmd"

      echo "${remote_leng//?/_}"
    ( echo "${remote_cmmd}"
      eval "${remote_cmmd}" ) | sed "s/^/$remote_user| /g"
done

exit
