#!/bin/env bash

_recordmydesktop() {
    recordmydesktop "$@" -o "video.ogv" --windowid $(xwininfo | egrep 'Window id' | awk '{print $4}') && mencoder video.ogv -ovc xvid -oac mp3lame -xvidencopts pass=1 -o video.avi
}

# Senza microfono:
_recordmydesktop --no-sound

# Con microfono:
_recordmydesktop --device hw:0,0
# nota per chi usa pulseaudio: inserire "--device pulse" al posto di "--device hw:0,0"

# ...in entrambi i casi:
#  *  per salvare  : Ctrl-Alt-S
#  *  per annullare: Ctrl-C

exit
