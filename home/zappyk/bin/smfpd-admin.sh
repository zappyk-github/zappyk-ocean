#!/bin/env bash

deamon_command='/etc/init.d/smfpd'
deamon_status="sudo $deamon_command check"
deamon_start="sudo $deamon_command start"
deamon_stop="sudo $deamon_command stop"

zenity_command="zenity --display=:0.0"
zenity_actions="FALSE stop TRUE status FALSE start"

type='-'
while [ -n "$type" ]; do
    result=`eval "$deamon_status"`

    type=`$zenity_command --list --radiolist --text="$result" --column "select" --column "$deamon_command" $zenity_actions`

    if [ -n "$type" ]; then
        [ "$type" == 'status' ] && command=$deamon_status
        [ "$type" == 'start'  ] && command=$deamon_start
        [ "$type" == 'stop'   ] && command=$deamon_stop

        result=`eval "$command" 2>&1` \
        && zenity --text="${result:+$result\n\n}rescue $type ok" --info \
        || zenity --text="${result:+$result\n\n}rescue $type error!" --error
    fi
done

exit
