#!/bin/env bash

file_mkv_input=$1
file_mp4_output=${file_mkv_input:+$file_mkv_input.avi}

command="ffmpeg -i $file_mkv_input -codec copy $file_mp4_output"

echo "$command"
eval "$command"
