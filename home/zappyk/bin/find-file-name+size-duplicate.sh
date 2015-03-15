#!/bin/env bash

PATH_BASE=$1
CHAR_LAST='§'

_find_name() {
    local path_base=$1
    local sort_size=$2

    [ -z "$path_base" ] && path_base='.'
    [ -z "$sort_size" ] && sort_size=false

    local name_path=''
    local name_file=''

    IFS=$'\n'
    for path_file in $(find $path_base -print0 | xargs -0 -i echo "{}"); do
        [ -d "$path_file" ] && continue
        name_path=$(dirname "$path_file")
        name_file=$(basename "$path_file")
        file_size=$(du -k "$path_file" | cut -f1)
        ( $sort_size ) \
        && printf "%10s %-70s [%s]\n" "$file_size$CHAR_LAST" "$name_file" "$name_path" \
        || printf "%-70s %10s [%s]\n" "$name_file$CHAR_LAST" "$file_size" "$name_path"
    done
}

_find_duplicate() {
    local path_base=$1
    local sort_size=$2
    local sort_opts=''

    ( $sort_size) && sort_opts='-n'

    local write_new=''
    local write_old=''
    local check_new=''
    local check_old=''

    local first=true
    local equal=false

    IFS=$'\n'
    for write_new in $(_find_name "$path_base" "$sort_size" | sort $sort_opts); do
        IFS=$CHAR_LAST read check_new other < <(echo "$write_new")

        if ( ! $first ); then
            if ( ! $equal ); then
                if [ "$check_old" == "$check_new" ]; then
                    echo "=|$write_old"
                    echo "=|$write_new"
                    equal=true
                else
                    equal=false
                fi
            else
                    echo " |$write_old"
            fi
        else
            first=false
        fi
        write_old=$write_new
        check_old=$check_new
    done
}

_find_duplicate "$PATH_BASE" false
_find_duplicate "$PATH_BASE" true

exit
