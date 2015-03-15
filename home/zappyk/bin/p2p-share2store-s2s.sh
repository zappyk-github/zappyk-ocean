#!/bin/env bash

wait_time=$1
path_list="$HOME/Scaricati/_COMPLEATE_" ; [ -n "$2" ] && path_list="$2"
path_save="$HOME/Scaricati/_INCOMING_"  ; [ -n "$3" ] && path_save="$3"

count=1

[ -z "$wait_time" ] && wait_time=5

_wait() {
    echo -e "\r[$count] sleep $wait_time seconds ...\c" && sleep $wait_time && count=$(($count + 1))
}

_noty() {
    file=$1
    name=`basename "$file"`
    zenity --display=:0.0 --notification --text="$name"&
}

_move() {
    file=$1
    name=`basename "$file"`
    mv -f "$file" "$path_save" && echo " >>> $name" && return 0
    return 1
}

_open() {
    file=$1
#CZ#name=`basename "$file"`
#CZ#open=`lsof | grep "$name"`
    open=`lsof -- "$file" 2>/dev/null`
    [ -n "$open" ] && return 0
    return 1
}

_save() {
    file=$1
    ! _open "$file" && _move "$file" && _noty "$file" && return 0
    return 1
}

_exec() {
    read file
    [ -e "$file" ] && echo && _save "$file" && return 0
    return 1
}

_find() {
    read path_from
    find "$path_from" -maxdepth 1 -type f -print0 | xargs -0 -i echo "{}" | _exec
}

_loop() {
    for path_from in $path_list; do
        [ -d "$path_from" ] && echo "$path_from" | _find
    done
}

while true; do
    _wait
    _loop
done

exit
