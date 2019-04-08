#!/bin/env bash

THIS=$(basename "$0" '.sh')

PASSWORD_LENG=${1:-8}
PASSWORD_TIME=${2:-1}
PASSWORD_CMPL=${3:-false}

NUMBER='0-9'
ALPHABET_a='a-z'
ALPHABET_A='A-Z'
PUNCTUATIONS='!$%()=?^:;'

PASSWORD_DEF1="0-90-9A-Z0-90-9a-z0-90-9"
PASSWORD_DEF2="A-Z!$%()=?^:;0-9!$%()=?^:;0-9A-Z0-9!$%()=?^:;0-9a-z0-9!$%()=?^:;0-9"
PASSWORD_DEF2="$ALPHABET_A$PUNCTUATIONS$PUNCTUATIONS$PUNCTUATIONS$NUMBER$PUNCTUATIONS$PUNCTUATIONS$PUNCTUATIONS$ALPHABET_a$ALPHABET_A$PUNCTUATIONS$NUMBER"

[ $PASSWORD_LENG -le 3 ] && echo "$THIS: non posso creare password meno di 3 caratteri" && exit 1

password_generator() {
    local len=$1
    [ "$len" == "" ] && len=16
    ( $PASSWORD_CMPL ) && PASSWORD_CHAR=$PASSWORD_DEF2 \
                       || PASSWORD_CHAR=$PASSWORD_DEF1
     tr -dc "$PASSWORD_CHAR" < /dev/urandom | head -c ${len} | xargs
}

for i in $(seq 1 $PASSWORD_TIME); do
password_generator "$PASSWORD_LENG"
done

exit
