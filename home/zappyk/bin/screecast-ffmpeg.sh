#!/bin/env bash

INFO=$(xwininfo -frame)

WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' | grep -oEe '[0-9]+x[0-9]+')
WIN_X_Y=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' | grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/\+/,/' )

ffmpeg -f x11grab -r 25 -b 2000k -s $WIN_GEO -i :0.0+$WIN_X_Y video.avi

exit
