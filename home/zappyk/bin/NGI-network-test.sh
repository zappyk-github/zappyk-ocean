#!/bin/env bash

THIS=`basename "$0"`
DATE=`date +%Y%m%d.%H:%M`

PATH_WORK='/home/zappyk/Desktop'
PING_HOST='maya.ngi.it'
WGET_FILE='http://gaming.ngi.it/test.zip'

cd "$PATH_WORK" || exit
rm -f "`basename "$WGET_FILE"`"

ping -c 100 "$PING_HOST" > "$THIS-ping-$DATE.log"

wget "$WGET_FILE"       -o "$THIS-wget-$DATE.log"

exit
