#yum install\
# xorg-x11-apps

#Comando Disabilita/Abilita Touchpad:
# [list       device] xinput list
# [list-props device] xinput list-props "PS/2 Generic Mouse"
# [disable  touchpad] xinput --set-prop "PS/2 Generic Mouse" "Device Enabled" 0
# [enable   touchpad] xinput --set-prop "PS/2 Generic Mouse" "Device Enabled" 1
#
#Automatizzare:
#+---------------------------------------------+
#| CREATE: /etc/udev/rules.d/61-touchpad.rules |
#+---------------------------------------------+
#|# 61-touchpad.rules
#|#
#|# this rules file must be named 61* or later because it won't work
#|# unless it runs after '/lib/udev/rules.d/60-persistent-input.rules'
#|#
#|# NOTE: will only affect DISPLAY :0
#|#
#|# run:
#|#   udevadm test --action=add /sys/devices/platform/i8042/serio1/input/input6/mouse1
#|# or similar to test the following rules
#|#
#|
#|# disable PS/2 touchpad on DISPLAY :0 if a mouse is added to the system
#|ACTION=="add", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", RUN+="/bin/sh -c 'DISPLAY=:0 /usr/bin/xinput --set-prop PS/2\ Generic\ Mouse Device\ Enabled 0'"
#|
#|# enable PS/2 touchpad on DISPLAY :0 if a mouse is removed from the system
#|ACTION=="remove", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", RUN+="/bin/sh -c 'DISPLAY=:0 /usr/bin/xinput --set-prop PS/2\ Generic\ Mouse Device\ Enabled 1'"
#+-------------------------------+
#| UPDATE: /etc/gdm/Init/Default |
#+-------------------------------+
#|# disable touchpad if more than one mouse is available
#|if [ `ls -d /sys/class/input/mouse* | wc -l` -gt 1 ]; then
#|    /usr/bin/xinput --set-prop PS/2\ Generic\ Mouse Device\ Enabled 0
#|fi
#+------------------------------------+
#| CREATE: /etc/pm/sleep.d/99touchpad |
#+------------------------------------+
#|#!/bin/sh
#|#
#|# disable touchpad if more than one mouse is available
#|#
#|# NOTE: will only affect DISPLAY :0
#|#
#|
#|disable_touchpad()
#|{
#|    /bin/sh -c 'DISPLAY=:0 /usr/bin/xinput --set-prop PS/2\ Generic\ Mouse Device\ Enabled 0'
#|}
#|
#|case "$1" in
#|    thaw|resume)
#|        if [ `ls -d /sys/class/input/mouse* | wc -l` -gt 1 ]; then
#|            disable_touchpad
#|        fi
#|        ;;
#|    *) exit $NA
#|        ;;
#|esac
