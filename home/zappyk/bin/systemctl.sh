#!/bin/env bash

cmd_screen='screen'

services=$(echo "$0" | cut -d'-' -f2-)

operation=${1:-$cmd_screen} ; shift

if [ "$operation" == "$cmd_screen" ]; then
    echo 'screen detach:   [Ctrl-a] [d]   or   [Ctrl-a] [Ctrl-d]'
    echo 'screen resize:   [Ctrl-a] [w]   or   [Ctrl-a] [Ctrl-w]'
    read -p 'press any key...'
    screen -r "$@"
else
    systemctl --user "$operation" "$@" "$services"
fi

exit
