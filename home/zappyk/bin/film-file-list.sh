#!/bin/env bash

PATH_BASE="$HOME/zappyk-hd/Public/Shared Videos"
PATH_FILM='Films'

FILE_SAVE="$HOME/zappyk-hd-Films.csv"

(cd "$PATH_BASE" && film-file-list.pl "$PATH_FILM" >"$FILE_SAVE-" && mv -f "$FILE_SAVE" "$FILE_SAVE~" && mv -f "$FILE_SAVE-" "$FILE_SAVE")

exit
