#!/bin/env bash

DEVICE_NAME=$1
DEVICE_SWITCH=$2
DEVICE_PROPERTY='Device Enabled'

BASE_PATH=$(cd -P $(dirname "$0") && pwd)

ZENITY_TITLE='touchpad disabled'
NOTIFY_TITLE='Switch Touchpad'
NOTIFY_ICON_ON='switch-touchpad-on.png'
NOTIFY_SEND_ON='...now is enabled!'
NOTIFY_ICON_OFF='switch-touchpad-off.png'
NOTIFY_SEND_OFF='now is disabled...'
NOTIFY_TIME_SLEEP=5000

_notify_systray_kill() {
    kill $(pgrep -f -u $USER "$NOTIFY_ICON_OFF")
}

_notify_systray_exec() {
#CZ#$BASE_PATH/notify-systray-2-alltray.sh "$DEVICE_NAME" "$ZENITY_TITLE" "$NOTIFY_ICON_OFF"
    $BASE_PATH/notify-systray.sh           "$DEVICE_NAME" "$ZENITY_TITLE" "$NOTIFY_ICON_OFF"
}

_notify_systray() {
    case "$DEVICE_SWITCH" in
        1 ) _notify_systray_kill ;;
        0 ) _notify_systray_exec ;;
    esac
}

_notify_send() {
    local icon=$1
    local mesg=$2
    notify-send -t "$NOTIFY_TIME_SLEEP" -i "$BASE_PATH/$icon" "$NOTIFY_TITLE" "$mesg"
}

_switch_notify() {
    case "$DEVICE_SWITCH" in
        1 ) _notify_send "$NOTIFY_ICON_ON"  "$NOTIFY_SEND_ON"  ;;
        0 ) _notify_send "$NOTIFY_ICON_OFF" "$NOTIFY_SEND_OFF" ;;
    esac
}

_device_switch() {
    xinput --set-prop "$DEVICE_NAME" "$DEVICE_PROPERTY" "$DEVICE_SWITCH"
}

_device_switch && _switch_notify && _notify_systray

exit
