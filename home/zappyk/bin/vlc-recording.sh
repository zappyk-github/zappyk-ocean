#!/bin/env bash
IFS_SAVE=$IFS

action=$1
stream=$2
fstore=$3

daynow=`date +'%F_%R'`
sstore=false

[ -z "$stream" ] && stream='http://localhost:16900/1.asf'
[ -z "$fstore" ] && fstore=`basename "$stream"` && sstore=true

[ -z "$action" ] && echo "$0: action is?" && exit 1
[ -z "$stream" ] && echo "$0: streaming?" && exit 1
[ -z "$fstore" ] && echo "$0: filestore?" && exit 1

file_save=`basename "$fstore"`
file_path=`dirname  "$fstore"` ; [ "$file_path" == '.' ] && file_path='/home/zappyk/Streaming'
file_name="${file_save%%.???}"
file_type="${file_save/$file_name./}"

[ -z "$file_name" ] && echo "$0: file name?" && exit 1
[ -z "$file_type" ] && echo "$0: file name?" && exit 1

file_out="$file_path/$file_name.$file_type"
file_set="$file_path/$daynow-$file_name.$file_type"

vlc_cmd="vlc $stream :http-caching=1200 --sout file/$file_type:$file_out"
vlc_cmd="vlc $stream --sout file/$file_type:$file_out"

dirname=`dirname "$0"`
basename=`basename "$0" '.sh'`
file_log="$dirname/$basename.log"

_log() {
	echo `date +'%F %T'`" | $*"
}

_start() {
	\rm -f $file_out
	eval "DISPLAY=:0.0 $vlc_cmd 2>&1 &" && _log "Comando ($vlc_cmd) avviato..."
}

_stop() {
	IFS=$'\n'
	for process in `ps -e -o pid,cmd | grep -v grep | grep "$vlc_cmd"`; do
		IFS=$IFS_SAVE
		read pid cmd < <(echo "$process")
		[ -n "$pid" ] && \kill $pid && _log "Comando ($cmd) fermato [$pid]."
	done
	IFS=$IFS_SAVE

        ( $sstore ) && mv -f "$file_out" "$file_set"
}

eval "_$action" >> $file_log

exit
