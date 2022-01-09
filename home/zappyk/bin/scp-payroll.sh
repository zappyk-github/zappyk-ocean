#!/bin/env bash

user=pes0zap ; [ "$USER" == 'root' ] && user=$USER
host=10.0.3.6  # vls.payroll
host=10.0.3.64 # sipert.payroll.local

directory=$1 ; shift
direction=$1 ; shift
filenames=$*

s=':'
verso='->'
osrev='<-'

case "$directory" in
    $verso | \
    $osrev ) [ -n "$filenames" ] && filenames="$filenames $direction" \
                                 || filenames="$direction"
             direction=$directory
             directory=''
             ;;
esac

case "$direction" in
    $verso ) local_filenames=''               ; remote_filenames="\"$filenames\"" ;;
    $osrev ) local_filenames="\"$filenames\"" ; remote_filenames=''         ;;
    *      ) echo "usage: $0 [ [[<host>$s]<directory>/]<file-remote> ] ( '$verso' | '$osrev' ) ( <file-local> ... )" && exit ;;
esac

h=''
d=''
IFS=$s read h d < <(echo "$directory")
[ -n "$d" ] && host=$h && directory=$d

[ -n "$directory" ] && directory="\"$directory\""

command="scp -r $local_filenames $user@$host:$directory $remote_filenames"
command="scp -oKexAlgorithms=+diffie-hellman-group1-sha1 -r $local_filenames $user@$host:$directory $remote_filenames"

echo "$command"
eval "$command"
