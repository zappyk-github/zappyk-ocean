#!/bin/env bash

HOST=${1:-smtp.gmail.com}
PORT=${2:-465}

 _CA_connect_FILE="$HOST.crt.pem"

#_CA_connect_Init() { echo -n | openssl s_client -connect $HOST:$PORT | perl -lne "print if /^-----/.../^-----/" >$_CA_connect_FILE; }
#_CA_connect_Init() { echo -n | openssl s_client -connect $HOST:$PORT            2>/dev/null | openssl x509 -outform PEM; }
 _CA_connect_Init() {           openssl s_client -connect $HOST:$PORT </dev/null 2>/dev/null | openssl x509 -outform PEM; }

 _CA_connect_Done() { openssl s_client -CAfile $_CA_connect_FILE -connect $HOST:$PORT; }

_CA_connect_Init && _CA_connect_Done

exit
