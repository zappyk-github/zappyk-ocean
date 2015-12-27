#!/bin/env bash

LIST_EXT='.avi .mkv .mp4'
FILE_EXT='.jpg'

PATH_BASE=${1:-./}

FIND_NAME=$(echo "$LIST_EXT" | sed 's/  */" -o -iname "\*/g')
FIND_NAME="\( -iname \"*$FIND_NAME\" \)"
FIND_FILE="find \"$PATH_BASE\" $FIND_NAME -print0 | xargs -0 -i echo \"{}\""

################################################################################
_wget_make() {
    local path_base=$1
    local find_files=$2

    path_base=$(dirname "$path_base")

    IFS=$'\n'
    for file in $(eval "$find_files"); do
        file_path=$(dirname  "$file")
        file_name=$(basename "$file")

        IFS=$' '
        for name_ext in $LIST_EXT; do
        file_name=$(basename "$file_name" "$name_ext");
        done

        file_img="$file_path/$file_name$FILE_EXT"

    #CZ#[ ! -e "$file_img" ] && get-imdb-FilmPoster.pl "$file_name" "$file_path/"
        [ ! -e "$file_img" ] && get-imdb-FilmPoster.pl "$file"
    done
}

_wget_make "$PATH_BASE" "$FIND_FILE"

exit
