#!/bin/env bash

cmd_screen='screen'
cmd_tmux__='tmux'

cmd_attach=$cmd_tmux__
cmd_attach=$cmd_screen

services=$(echo "$0" | cut -d'-' -f2-)

operation=${1:-$cmd_attach} ; shift

  if [ "$operation" == "$cmd_screen" ]; then
    echo 'screen detach:   [Ctrl-a] [d]   or   [Ctrl-a] [Ctrl-d]'
    echo 'screen resize:   [Ctrl-a] [w]   or   [Ctrl-a] [Ctrl-w]'
    read -p 'press any key...'
    screen -r "$@"
elif [ "$operation" == "$cmd_tmux__" ]; then
    echo "...?..."
else
#CZ#systemctl --user "$operation" "$@" "$services"
    name=$services
    prog=$(which "$services")
    pids=$(pidof "$prog")
    case "$operation" in
        start  ) if [ -z "$pids" ]; then
                     echo "$name prapare to start..."
                     /usr/bin/screen -d -m -fa -S "$name" "$prog"
                     sleep 1
                 fi
                 $0 status
                 ;;
        stop   ) if [ -n "$pids" ]; then
                     echo "$name prepare to stop..."
                     /usr/bin/killall -w -s 9 "$prog"
                     sleep 1
                 fi
                 $0 status
                 ;;
        status ) [ -n "$pids" ] && echo "$name on pid $pids is running..." \
                                || echo "$name is not running!"
                 ;;
        *      ) echo "$0 [ start | stop | status | $cmd_attach ]" ;;
    esac
fi

exit
