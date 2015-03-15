#!/bin/env bash

cmd="vlc -vvv dv/rawdv:///dev/raw1394 -dv-caching 10000 --sout '#transcode{vcodec=WMV2,vb=512,scale=1,acodec=mp3,ab=192,channels=2}:std{access=mmsh,mux=asfh,url=:8080}' --sout-transcode-fps=25.0"
cmd="vlc dv:///dev/fw1"

eval "$cmd"
