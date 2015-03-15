#!/bin/env bash

file_iso_image=$1
mount_path_base='/mnt/loop'

name_iso_image=`basename "$file_iso_image"`
name_iso_image=`echo "$name_iso_image" | sed 's/\.iso//i' | sed 's/\.img//i'`
mount_path="$mount_path_base/$name_iso_image"

if [ "`mount | grep "$file_iso_image"`" == "" ]; then
	mkdir -p "$mount_path" && \
	sudo mount -o loop "$file_iso_image" "$mount_path"
else
	echo "`basename $0`: $file_iso_image alredy mounted!"
fi

exit
