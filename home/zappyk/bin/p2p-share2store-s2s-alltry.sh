#!/bin/env bash

sleep_sec=60
wait_time=$1

[ -n "${wait_time/[0-9]*[0-9]/}" ] && wait_time='' || shift
[ -z "$wait_time" ] && wait_time=$sleep_sec

file_name=`basename "$0" '.sh'`
icon_name=`dirname "$0"`"/$file_name.gif"

alltray --icon "$icon_name" $* "gnome-terminal -e \"p2p-share2store-s2s.sh $wait_time\" -t \"p2p >>> s2s\"" &

exit
