#!/bin/env bash

read name GEOMETRY other < <(DISPLAY=:0.0 xdpyinfo | grep 'dimensions:')
read      GEOMETRY other < <(DISPLAY=:0.0 xrandr | grep '*')

if [ -n "$GEOMETRY" ]; then
	echo "Autodetect geometry: $GEOMETRY"
	GEOMETRY="geometry=$GEOMETRY"
else
	echo "Autodetect geometry not found"
	GEOMETRY=''
fi

vncviewer QualityLevel=5 CompressLevel=5 $GEOMETRY Shared=1 LowColorLevel=1 "$@"

exit
