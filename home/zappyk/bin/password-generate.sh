#!/bin/env bash

PASSWORD_LENGTH=$1 ; [ -z "$PASSWORD_LENGTH" ] && PASSWORD_LENGTH=8
PASSWORD_NUMBER=$2 ; [ -z "$PASSWORD_NUMBER" ] && PASSWORD_NUMBER=4

SET_ALFABET='a-zA-Z'
SET_NUMBERS='0-9'
SET_SYMBOLS='_!@#$%^&*()+[]|:<>?='
SET_SYMBOLS='_!@#$%'

DEV_RANDOM0=''
DEV_RANDOM1='/dev/random'
DEV_RANDOM2='/dev/urandom'

[ -e "$DEV_RANDOM1" ] && DEV_RANDOM0=$DEV_RANDOM1
[ -e "$DEV_RANDOM2" ] && DEV_RANDOM0=$DEV_RANDOM2

[ -z "$DEV_RANDOM0" ] && echo "$0:  device random not found!" && exit 1

cat "$DEV_RANDOM0" | tr -dc "$SET_ALFABET$SET_NUMBERS$SET_SYMBOLS" | fold -w $PASSWORD_LENGTH | head -n $PASSWORD_NUMBER

exit
