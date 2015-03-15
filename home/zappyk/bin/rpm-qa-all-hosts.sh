#!/bin/env bash

domain='.ocean'
this_host=`basename "$HOSTNAME" "$domain"`

rpm_command='rpm -qa | sort'

for name_host in zappyk-mc zappyk-ws zappyk-nb; do
    ssh_command=''
    [ "$this_host" != "$name_host" ] && ssh_command="ssh $name_host "

    command="$ssh_command$rpm_command > rpm-qa.$name_host.log"

    echo -n "Execute '$command' on $name_host ... "
    eval "$command"
    echo    "done."
done

exit
