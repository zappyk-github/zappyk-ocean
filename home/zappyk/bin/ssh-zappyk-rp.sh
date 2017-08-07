#!/bin/env bash

host='pi@zappyk-rp'
pswd='raspberry'
cmmd="ssh $host"

echo "$host [$pswd]"
eval "$cmmd"

exit
