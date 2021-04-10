#!/bin/env bash

file_mkv_input=$1 ; shift
file_mp4_output=${file_mkv_input:+$file_mkv_input.avi}

 command="ffmpeg -i $file_mkv_input -codec copy                         $* $file_mp4_output"
#command="ffmpeg -i $file_mkv_input -codec copy -bsf:v h264_mp4toannexb $* $file_mp4_output"

echo "$command"
eval "$command"
