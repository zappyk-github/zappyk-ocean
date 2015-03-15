#!/bin/env bash

script_daemon=$1
host_name=${2:-$HOSTNAME}

die() {
    local string="$*"
    echo -e "$string"
    [ -z "$script_daemon" ] && script_daemon='?????'
    zenity --title="$script_daemon" --error --text="$string"
    exit 1
}

execute() {
    name_daemon=`basename $script_daemon`
    ssh -t -t $host_name sudo /sbin/service "$name_daemon" "$*" 2>/dev/null
    return 0
}

create_actions_list() {
    set -o pipefail
    execute | cut -d'{' -f2 | cut -d'}' -f1 | sed 's/ /_/g' | sed 's/|/ FALSE /g'
    return 0
}

create_list() {
    local create_list=`create_actions_list`
    [ -n "$create_list" ] && echo "FALSE $create_list" && return 0 || return 1
}

check_execute() {
    [ -z "$script_daemon" ] && return 1 || return 0
}

xxx='\x1B'
tab='\[60G'
red='\[0;31m'
green='\[0;32m'
normal='\[0;39m'

basename=`basename $0`
help_string="Usage: $basename \"program-daemon\""
escape_filter="sed 's/$xxx/\t/' | sed 's/$xxx//g' | sed 's/$tab//g' | sed 's/$red//g' | sed 's/$green//g' | sed 's/$normal//g'"

check_execute                   || die "$help_string\n\n$basename: Lo script '$basename' non puo' essere lanciato."
actions_list=`create_list`      || die "$basename: Non riesco a determinare la lista delle azioni per lo script '$script_daemon'... ($actions_list)"
actions_status=`execute status` || die "$basename: Non riesco a determinare lo 'stato' dello script '$script_daemon'... ($actions_status)"

actions_selected=`zenity --title='$script_daemon' --list --text="$actions_status" --radiolist --width=100 --height=350 --column 'select' --column 'Action' $actions_list`

[ -n "$actions_selected" ] && output_execute=`execute $actions_selected | eval "$escape_filter"`
[ -n "$output_execute"   ] && zenity --title="$script_daemon $actions_selected" --info --text="$output_execute"

exit
