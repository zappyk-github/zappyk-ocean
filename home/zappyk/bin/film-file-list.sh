#!/bin/env bash

PATH_BASE="$HOME/mnt-zappyk-hd/Public/Videos"
PATH_BASE='/dfs/zappyk-hd/Public/Videos'
PATH_FILM='Films'

FILE_SAVE="$HOME/mnt-zappyk-hd-Films.csv"
FILE_SAVE="$HOME/zappyk-hd-Films.csv"

( cd "$PATH_BASE" && film-file-list.pl "$PATH_FILM" )

( cd "$PATH_BASE" && film-file-list.pl "$PATH_FILM" >"$FILE_SAVE-" && ( [ -e "$FILE_SAVE" ] && mv -f "$FILE_SAVE" "$FILE_SAVE~" || cp -f "$FILE_SAVE-" "$FILE_SAVE~" ) && mv -f "$FILE_SAVE-" "$FILE_SAVE" )

exit
