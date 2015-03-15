#!/bin/env bash

cmmd="$*"

info=$(eval "$cmmd" 2>/dev/null)

many=`echo -n $info | wc -w`
many=$((1000 + 500*$many))

notify-send -t $many -u low -i gtk-dialog-info "$cmmd" "$info" || exit 2

exit
