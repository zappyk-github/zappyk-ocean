#!/bin/env bash

FILE=$1 ; shift
UTFx=$*

[ ! -n "$UTFx" ] && UTFx='utf16..utf8'
[ ! -n "$FILE" ] && echo "$0: specifica il file da convertire da $UTFx" && exit 1
[ ! -r "$FILE" ] && echo "$0: il file '$FILE' non puo' essere letto e convertito da $UTFx" && exit 1

recode $UTFx "$FILE"

exit
