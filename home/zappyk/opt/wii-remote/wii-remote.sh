#!/bin/env bash

wii_remote_conf="$HOME/.CWiid/wminput.conf"
wii_remote_icon="$HOME/Programmi/wii-remote/wii-remote.png"

command_0="sudo /usr/bin/wminput        --config $wii_remote_conf"
command_0="sudo /usr/bin/wminput --wait --config $wii_remote_conf"
command_1="gnome-terminal --command '$command_0' --title='wii remote'"

alltray --show --icon "$wii_remote_icon" "$command_1" \
&& zenity --text="wii remote not running" --info \
|| zenity --text="wii remote error load!" --error

exit
