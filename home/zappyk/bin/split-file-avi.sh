#!/bin/env bash

FILE_AVI=$1
TIME_STR=$2
TIME_END=$3
FILE_SPL=$4

[ -z "$FILE_AVI" ] && exit
[ -z "$TIME_STR" ] && TIME_STR='00:10:00'
[ -z "$TIME_END" ] && TIME_END='00:20:00'
[ -z "$FILE_SPL" ] && TIME_SPL="$FILE_AVI-split.avi"

mencoder -ss "$TIME_STR" -endpos "$TIME_END" -ovc copy -oac copy "$FILE_AVI" -o "$FILE_SPL"
