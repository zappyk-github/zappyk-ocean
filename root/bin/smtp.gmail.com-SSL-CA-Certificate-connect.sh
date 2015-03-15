#!/bin/env bash

HOST='smtp.gmail.com'
PORT=465

_CA_connect_FILE="$HOST.crt.pem"

_CA_connect_Init() { echo -n | openssl s_client -connect $HOST:$PORT | perl -lne "print if /^-----/.../^-----/" >$_CA_connect_FILE; }

_CA_connect_Done() { openssl s_client -CAfile $_CA_connect_FILE -connect $HOST:$PORT; }

_CA_connect_Init && _CA_connect_Done

exit
