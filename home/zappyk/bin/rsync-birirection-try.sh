#!/bin/env bash

DIR_SRC=$1 ; shift
DIR_DST=$1 ; shift

DRY_RUN='-n' ; [ "$1" == 'ok' ] && shift && DRY_RUN=''

[ ! -d "$DIR_SRC" ] && echo "Attenzione, directory sorgente '$DIR_SRC' inesistente..." && exit 1
[ ! -d "$DIR_DST" ] && echo "Attenzione, directory destinazione '$DIR_DST' inesistente..." && exit 1

_RSYNC_="rsync -rvl      $DRY_RUN"
_RSYNC_="rsync -rvlptgoD $DRY_RUN"
_RSYNC_="rsync -rva      $DRY_RUN"

TX_NORM='\e[0m'
TX_BOLD='\e[1m'

_echo() {
    local string=$*
    echo -e "$TX_BOLD#_${string//?/_}_$TX_NORM"
    echo -e "$TX_BOLD# ${string} $TX_NORM"
}
_exec() {
    local string=$*
    eval "$string"
}
_eval() {
    local string=$*
    _echo "$string"
    _exec "$string"
}
_sync_exe()    { _eval $_RSYNC_ "$@"; }
_sync_eval()   { _sync_going "$@" ; _sync_return "$@"; }
_sync_going()  { _sync_exe "$@" "\"$DIR_SRC\"" "\"$DIR_DST\""; }
_sync_return() { _sync_exe "$@" "\"$DIR_DST\"" "\"$DIR_SRC\""; }

_sync_eval "$@"

exit
