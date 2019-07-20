#!/bin/env bash

path_tmp=${1:-.}
name_tmp='tempfile'
file_tmp="$path_tmp/$name_tmp"

[ ! -d "$path_tmp" ] && file_tmp="$path_tmp"

[   -e "$file_tmp" ] && echo "Error: $file_tmp exists!" && exit 1

time {
echo "#==================="
echo "# Speed Test [WRITE] $file_tmp"
sync; dd if=/dev/zero of="$file_tmp" bs=1M count=1024; sync;
echo "#==================="

echo "#==================="
echo "# Speed Test [READ ] $file_tmp"
sync; dd if="$file_tmp" of=/dev/zero bs=1M count=1024; sync;
echo "#==================="
}

rm -fv "$file_tmp"

exit
