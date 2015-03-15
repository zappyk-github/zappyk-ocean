#!/bin/env bash

file_avi_input=$1
file_mp4_output=${file_avi_input:+$file_avi_input.mp4}

command="ffmpeg -y -i $file_avi_input -b 768 -s 320x240 -vcodec xvid -ab 128 -acodec aac -ac 2 -ab 64 -f mp4 $file_mp4_output"
command="ffmpeg -i $file_avi_input -f formato $file_mp4_output"

echo "$command"
eval "$command"
