#!/bin/env bash

_to_='zappyk@gmail.com'
mssg="$*"

[ -z "$mssg" ] && mssg='Nothing to do!'

mailsend --subject "rtorrent@$HOSTNAME file done" --to "$_to_" --msg "$mssg"

exit
