#!/bin/env bash

MYLIST_HOSTS='zappyk-ws zappyk-mc zappyk-zb zappyk-nb zappyk-rp1 zappyk-rp2'

REMOTE_HOSTS=${1:-$MYLIST_HOSTS} ; shift
LOCALE_PROGR=${1} ; shift
LOCALE_PARAM=$*
LOCALE_CMMDS="$LOCALE_PROGR $LOCALE_PARAM"
REMOTE_CMMDS="source .bash_profile ; $LOCALE_CMMDS"
REMOTE_USERS=$USER

THISHOSTNAME=$(hostname -f)

    [ -z "$LOCALE_CMMDS" ] && echo -e "Specifica un comando da eseguire in remoto\n come utente ( $REMOTE_USERS )\n sugli hosts [ $REMOTE_HOSTS ]" && exit 1
#CZ#[ -z "$LOCALE_PARAM" ] && echo '...nessun parametro...?' && read

for remote_host in $REMOTE_HOSTS; do
    remote_user="$REMOTE_USERS@$remote_host"
    remote_cmmd="ssh $remote_user \"$REMOTE_CMMDS\""
    remote_cmmd="ssh $remote_user \"$REMOTE_CMMDS\" 2>&1"

#CZ#[ "$THISHOSTNAME" == "$remote_host" ] && continue
    [ "$THISHOSTNAME" == "$remote_host" ] && remote_cmmd="$LOCALE_CMMDS"

    remote_tags="$remote_user| "
    remote_leng="$remote_tags$remote_cmmd"
    remote_line=${remote_leng//?/_}

    echo "$remote_line"
    echo "$remote_leng"
    eval "$remote_cmmd" | sed "s/^/$remote_tags/g"
done

exit
