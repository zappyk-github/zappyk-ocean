#!/bin/env bash
#
TAG_FILE='normalization-'
#
# Io ho preso 4 spezzoni di video differenti, con le seguenti risoluzioni:
#
#    320 × 240
#    384 × 288
#    320 × 136
#    480 × 360
#
# quindi ho scelto di portarli tutti in hd720 (1280×720), ed ho usato il seguente comando:
#
for file_avi in *.avi; do ffmpeg -y -i "$file_avi" -f avi -vcodec mpeg4 -b 8000000 -acodec ac3 -ab 128000 -s hd720 "$TAG_FILE$file_avi"; done
#
#
#
# a questo punto si possono unire i 4 video:
#
mencoder "$TAG_FILE"*.avi -oac mp3lame -ovc xvid -xvidencopts pass=1 -o "$TAG_FILE-united-video.avi"
#
#
#
exit
