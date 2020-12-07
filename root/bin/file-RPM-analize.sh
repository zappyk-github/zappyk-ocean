#!/bin/env bash

FILE=${1} ; [ -z "$FILE" ] && echo "$(basename "$0") <FILE | DIRECTORY> (true)" && exit 1
INIT=${2:-false}

NONE='---'
PACK='# '
SIZE=': '
NEXT='.'

( $INIT ) && find "$FILE" | xargs -i bash -c "$0 \"{}\"" && exit

FILEsPACK=$(rpm -qf "$FILE") ; [ $? == 1 ] && FILEsPACK=$NONE
FILE_SIZE=$(du -sh "$FILE")

IFS=$'\n'
first=true
for FILE_PACK in $FILEsPACK; do
	( ! $first ) && echo "$NEXT"
	printf "$PACK%-60s" "$FILE_PACK"
	first=false
done
	echo "$SIZE$FILE_SIZE"

exit
