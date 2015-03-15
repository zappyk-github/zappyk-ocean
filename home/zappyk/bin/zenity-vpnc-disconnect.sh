#!/bin/env bash

command_0="sudo /usr/sbin/vpnc-disconnect"
command_0="beesu vpnc-disconnect"
command_1="gnome-terminal -e '$command_0' -t 'vpn disconnect'"
sleepwait=1

eval "alltray --sticky --notray \"$command_1\"" &

ps=`sleep $sleepwait && ps -ef | grep -v grep | grep -e 'alltray' -e "$command_1"`
[ -n "$ps" ] && zenity --display=:0.0 --text="vpn disconnected" --info \
             || zenity --display=:0.0 --text="vpn not disconnected" --error

exit
