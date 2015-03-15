#!/bin/env bash

DEVICE_NAME=$1 ; [ -z "$DEVICE_NAME" ] && exit
NOTIFY_TIT=$2  ; [ -z "$NOTIFY_TIT"  ] && exit
FILE_ICON=$3   ; [ -z "$FILE_ICON"   ] && exit

BASE_PATH=$(cd -P $(dirname "$0") && pwd)

XINPUT_CHECK='This device is disabled'
XINPUT_LIST=''

_xinput_check() {
          XINPUT_LIST=$(xinput list "$DEVICE_NAME")
    local xinput_grep=$(echo "$XINPUT_LIST" | grep -i "$XINPUT_CHECK")
    [ -n "$xinput_grep" ] && return 1
    return 0
}

_zenity() {
    cat << _EOD_
    zenity \
    --window-icon="$BASE_PATH/$FILE_ICON" \
    --title="$NOTIFY_TIT" \
    --no-wrap \
    --text="$XINPUT_LIST" \
    --info
_EOD_
}

_alltray() {
    _xinput_check && return 1
    alltray \
    --icon "$BASE_PATH/$FILE_ICON" \
    --large_icons \
    --sticky \
    --skip-taskbar \
    --nominimize \
    "$(_zenity)"
}

_main() {
    loop=true
    while $loop; do
        _alltray &>/dev/null
        [ $? -ne 0 ] && loop=false
    done
}

_main &

exit
