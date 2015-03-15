#/bin/env bash

DEVICE_NAME=$1 ; [ -z "$DEVICE_NAME" ] && exit
NOTIFY_TIT=$2  ; [ -z "$NOTIFY_TIT"  ] && exit
FILE_ICON=$3   ; [ -z "$FILE_ICON"   ] && exit
FILE_EXEC='notify-systray-1-zenity.sh'

BASE_PATH=$(cd -P $(dirname "$0") && pwd)

_alltray() {
 alltray \
 --icon "$BASE_PATH/$FILE_ICON" \
 --large_icons \
 --sticky \
 --skip-taskbar \
 --nominimize \
 "$BASE_PATH/$FILE_EXEC '$DEVICE_NAME' '$FILE_ICON' '$NOTIFY_TIT'"
}

loop=true
while $loop; do
    _alltray &>/dev/null
    [ $? -ne 0 ] && loop=false
done

exit
