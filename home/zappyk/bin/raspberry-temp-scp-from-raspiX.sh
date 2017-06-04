#!/bin/env bash

this=$(basename "$0" '.sh')

hostcopy='1 2'
host_tag='zappyk-rp%s'
file_tag='log/raspi%s-raspberry-temp-check.csv'
dir_copy="."
dateuniq="$dir_copy/$this.csv"

filelist=
for i in 1 2; do
    host=$(printf "$host_tag" "$i")
    file=$(printf "$file_tag" "$i")
    name=$(basename "$file")
    scp $host:"$file" "$dir_copy"

    filelist="$filelist \"$dir_copy/$name\""
done

eval "cat $filelist | cut -d';' -f3 | sort -u >\"$dateuniq\""

eval "libreoffice $filelist \"$dateuniq\""&

exit
