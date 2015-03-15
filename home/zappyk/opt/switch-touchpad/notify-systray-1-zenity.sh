#/bin/env bash

DEVICE_NAME=$1 ; [ -z "$DEVICE_NAME" ] && exit
NOTIFY_TIT=$2  ; [ -z "$NOTIFY_TIT"  ] && exit
FILE_ICON=$3   ; [ -z "$FILE_ICON"   ] && exit

BASE_PATH=$(cd -P $(dirname "$0") && pwd)
XINPUT_LIST=$(xinput list "$DEVICE_NAME")

_zenity() {
 zenity \
 --window-icon="$BASE_PATH/$FILE_ICON" \
 --title="$NOTIFY_TIT" \
 --no-wrap \
 --text="$XINPUT_LIST" \
 --info
}

_zenity &>/dev/null

exit
