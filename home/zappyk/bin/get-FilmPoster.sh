#!/bin/env bash

THIS=$(basename "$0" '.sh')
PROG="$THIS.pl"
CMMD=$(which "$PROG" 2>/dev/null)

[ -z "$CMMD" ] && echo "$THIS: error, related command '$PROG' not found!" && exit 1

LIST_EXT='.avi .mkv .mp4'
FILE_EXT='.jpg'

PATH_BASE=${1:-./}
WWW_IMAGE=${2}
EXEC_BASH=${3}
URL_EMPTY='-'

FIND_NAME=$(echo "$LIST_EXT" | sed 's/  */" -o -iname "\*/g')
FIND_NAME="\( -iname \"*$FIND_NAME\" \)"
FIND_FILE="find \"$PATH_BASE\" $FIND_NAME -print0 | xargs -0 -i echo \"{}\""

FILE_BASH="$THIS-$(date +'%Y%m%d').sh"
FILE_null='/dev/null'

[ -n "$WWW_IMAGE" ] && FILE_BASH=$FILE_null

################################################################################
_echo_recursive() {
    local file=$1

    echo "##$THIS.sh \"$file\" \"$URL_EMPTY\""
}

################################################################################
_wget_echo() {
    local www_image=$1
    local file_img=$2
    local wget_tag=' '

    [ "$www_image" == "$URL_EMPTY" ] && wget_tag='#'

    echo "$wget_tag wget -cq \"$www_image\" -O \"$file_img\""
}

################################################################################
_wget_make() {
    local path_base=$1
    local www_image=$2
    local find_files=$3
    local exec_wget=$4

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

        if [ ! -e "$file_img" ]; then
            if [ -n "$www_image" ]; then
		if [ -n "$exec_wget" ]; then
                    _wget_echo "$www_image" "$file_img" | eval "$exec_wget"
		else
                    _wget_echo "$www_image" "$file_img"
		fi
            else
                $CMMD "$file" || _echo_recursive "$file"
            fi
        fi
    done
}

_wget_make "$PATH_BASE" "$WWW_IMAGE" "$FIND_FILE" "$EXEC_BASH" 2>&1 | tee "$FILE_BASH"

[ ! -s "$FILE_BASH" ] && [ "$FILE_BASH" != "$FILE_null" ] && rm -f "$FILE_BASH" && echo "# ...nessuna locandina da trovare..."

exit
