#!/bin/env bash

THIS=`basename $0 '.sh'`
DATE=`date +%F`
FILE="$THIS-$HOSTNAME-$DATE"

for dir in /etc; do
    tag=`echo "$dir" | sed 's#/#%#g'`
    tar czf "$FILE-$tag.tar.gz" $dir
done
