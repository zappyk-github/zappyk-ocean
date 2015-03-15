#!/usr/bin/env bash

path_file="$1"
name_file=`basename "$path_file"`
path_save="$HOME/Scaricati/_INCOMING_" ; [ -n "$2" ] && path_save="$2"
file_save="$path_save/$name_file"
play_info='/usr/share/sounds/info.wav'
play_store='/usr/share/sounds/phone.wav'
play_error='/usr/share/sounds/error.wav'
zenity_notify='zenity --display=:0.0 --notification'

################################################################################

set_sep='='
set_dir_incoming='IncomingDir'
set_file_conf="$HOME/.aMule/amule.conf"
dir_incoming=''
IFS=$set_sep read variable dir_incoming < <(grep "$set_dir_incoming$set_sep" "$set_file_conf")

[ -n "$path_file" ] && [ "$path_file" == "$name_file" ] && path_file="$dir_incoming/$name_file"

################################################################################

_play() {
    local file=$1
    local volume=$2
    local repeat=$3

    [ ! -e "$file" ] && return

    [ -z "$volume" ] && volume=1
    [ -z "$repeat" ] && repeat=1

    for i in `seq 1 $repeat`; do play -q --volume $volume "$file"; done
}

_play_info()  { _play "$play_info"  5 3; }
_play_store() { _play "$play_store" 5 3; }
_play_error() { _play "$play_error" 5 3; } 

################################################################################

[   -z "$path_file" ] && eval "$zenity_notify --text=\"Nessun file specificato!\" &"         && _play_info && exit 1
[   -f "$file_save" ] && eval "$zenity_notify --text=\"$name_file >>> Gia' esistente!\" &"   && _play_info && exit 1
[   -d "$path_file" ] && eval "$zenity_notify --text=\"$path_file >>> E' una directory!\" &" && _play_info && exit 1
[ ! -e "$path_file" ] && eval "$zenity_notify --text=\"$path_file >>> Non esiste!\" &"       && _play_info && exit 1
[ ! -s "$path_file" ] && eval "$zenity_notify --text=\"$path_file >>> E' un file vuoto!\" &" && _play_info && exit 1

mv "$path_file" "$path_save" 2>/dev/null

[ $? -eq 0 ] && { eval "$zenity_notify --text=\"$name_file >>> salvato\" &" && _play_store && exit 0; } \
             || { eval "$zenity_notify --text=\"$name_file >>> errore!\" &" && _play_error && exit 1; }

exit

################################################################################
#
#set_sep='='
#set_dir_temp='TempDir'
#set_dir_incoming='IncomingDir'
#set_file_conf="$HOME/.aMule/amule.conf"
#
#dir_temp=''
#IFS=$set_sep read variable dir_temp     < <(grep "$set_dir_temp$set_sep"     "$set_file_conf")
#dir_incoming=''
#IFS=$set_sep read variable dir_incoming < <(grep "$set_dir_incoming$set_sep" "$set_file_conf")
#
#echo "|$dir_temp|"
#echo "|$dir_incoming|"
#
#exit
