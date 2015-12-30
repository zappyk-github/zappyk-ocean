#!/bin/env bash

REMOTE_HOSTS='zappyk-ws zappyk-mc zappyk-zb zappyk-nb'
THISHOSTNAME=$(hostname -f)

LOCALE_CMMDS="svn-admin-repos.sh $*"
REMOTE_CMMDS="source .bash_profile ; $LOCALE_CMMDS"
REMOTE_USERS=$USER

for remote_host in $REMOTE_HOSTS; do
    remote_user="$REMOTE_USERS@$remote_host"
    remote_cmmd="ssh $remote_user \"$REMOTE_CMMDS\""

#CZ#[ "$THISHOSTNAME" == "$remote_host" ] && continue
    [ "$THISHOSTNAME" == "$remote_host" ] && remote_cmmd="$LOCALE_CMMDS"

    remote_tags="$remote_user| "
    remote_leng="$remote_tags$remote_cmmd"

      echo "${remote_leng//?/_}"
    ( echo "${remote_cmmd}"
      eval "${remote_cmmd}" ) | sed "s/^/$remote_user| /g"
done

exit
