#!/bin/env bash

OWNER='zappyk'

SLEEP=10
SLEEP=2

myself_root() {
    [ `id -u` -eq 0 ] && return 0
    return 1
}

run_user() {
    local owner="$1" ; shift
    local commands="$*"
    su -c "$commands" - "$owner"
}

run() {
    local owner="$1" ; shift
    local commands="$@"
    if ( myself_root ); then
        run_user "$owner" "$commands"
    else
        eval "$commands"
    fi
}

BASE=$HOME
( myself_root ) && BASE=`run_user "$OWNER" 'echo $HOME'`
BASE_saves=`ls -d $BASE/{Documenti,Musica,Video}/_INCOMING_ 2>/dev/null`

BASE_TEMP_aMule="$BASE/.aMule/Temp/*part"
BASE_INCO_aMule="$BASE/.aMule/Incoming"
BASE_TEMP_mldonkey="/var/cache/mldonkey"
BASE_INCO_mldonkey="/var/lib/mldonkey/incoming/files"
BASE_INCO_archive="$BASE/Scaricati/_INCOMING_"
BASE_INCO="\
$BASE_INCO_aMule
$BASE_INCO_mldonkey
"

ins_string() {
    local string_start="$1" ; shift
    local string_end="$1" ; shift
    while read line; do
        echo "$string_start$line$string_end" 
    done
}

check_download() {
    local dir=$1
    IFS=$'\n'
#CZ#for file in `find $dir -follow -maxdepth 1 -type f -print0 | sort | xargs -0 -i echo {}`; do
    {
    local tot=0
    for file in `find $dir -follow -maxdepth 1 -type f -print0 | xargs -0 -i echo {}`; do
        file_size=`du -sm $file | cut -f1`
        file_type=`file $file | cut -d':' -f2-`
    #CZ#echo "$file_size:$file_type"
        printf "%-8s\t| %-25s : %s\n" "$file_size" "$file" "$file_type"
        len=`echo "$file_size" | cut -f1`
        tot=$(($tot + $len))
    done;
    [ $tot -ne 0 ] && echo "$tot"
    } | sort -n
}

check_saves() {
    local dir_root=$1
    local first=true
    IFS=$'\n'
#CZ#for dir in `find $dir_root -type d -print0 | sort | xargs -0 -i echo {}`; do
    (
    for dir in `find $dir_root -type d -print0 | xargs -0 -i echo {}`; do
        ( ! $first ) && echo
        du -smc "$dir"/* | ins_string "\ \ \ " "" 
        first=false
    done
    ) | sort -n -r -s
}

detect_download() {
    local dir=$1
    local sep=$2
    echo "$sep"
    echo "$dir :"
    check_download "$dir"
}

detect_saves() {
    local dir=$1
    echo "$dir :"
    check_saves "$dir"
    echo
}

process_aMule() {
    detect_download "$BASE_TEMP_aMule" '------------------------------------------------------------------------------'
    echo
    detect_download "$BASE_INCO_aMule" '=============================================================================='
}

process_mldonkey() {
    detect_download "$BASE_TEMP_mldonkey" '------------------------------------------------------------------------------'
    echo
    detect_download "$BASE_INCO_mldonkey" '=============================================================================='
}

process_saves() {
    for dir in $BASE_saves; do
    	detect_saves "$dir"
    done
}

cmd() {
    local string_start="$1" ; shift
    local string_end="$1" ; shift
#CZ#eval "$@" 2>&1 | ins_string "$string_start" "$string_end"
    eval "$@" 2>/dev/null | ins_string "$string_start" "$string_end"
}

main() {
    process_saves
    process_aMule
    echo
    process_mldonkey
}

normal() {
    cat << _EOD_
+-------------------------------------------------------------------------------
|
`cmd "| " "" main`
|
+-------------------------------------------------------------------------------
_EOD_
}

normal_gui() {
    local file_log='/tmp/p2p.log'
#CZ#local commands="DISPLAY=:0.0 zenity --text-info --width=2000 --height=1000 --filename=\"$file_log\""
    local commands="zenity --display=:0.0 --text-info --width=2000 --height=1000 --filename=\"$file_log\""
    cmd " " "" main &> "$file_log"
    run "$OWNER" "$commands"
    rm -f "$file_log"
}

archive() {
    IFS=$'\n'
    for dir in $BASE_INCO; do
        for file in `ls "$dir" 2>/dev/null`; do
            sleep $SLEEP
            mv "$dir/$file" "$BASE_INCO_archive"
            echo "$file"
        done
    done
}

archive_gui() {
    IFS=$'\n'
    for file in `archive`; do
    #CZ#commands="DISPLAY=:0.0 zenity --notification --text=\"$file\" &"
        commands="zenity --display=:0.0 --notification --text=\"$file\" &"
        run "$OWNER" "$commands"
    done
}

case "$1" in
    archive     ) archive     ;;
    archive-gui ) archive_gui ;;
    gui         ) normal_gui  ;;
    *           ) normal      ;;
esac

exit
