#!/bin/env bash

date=`date +'%F'`
fout="desktop-recorder-$date.mpg"
flog="desktop-recorder-$date.log"
prms="-f x11grab -s wxga  -r 25 -i $DISPLAY -sameq"
prms="-f x11grab -s wsxga -r 25 -i $DISPLAY -sameq"

ffmpeg $prms -y "$fout" 2>&1 | tee "$flog"

exit
