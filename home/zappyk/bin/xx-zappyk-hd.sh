#!/bin/env bash

this=$(basename "$0")

cmmd_prog=${this:0:2} 
notify_to='zappyk@gmail.com'

################################################################################
_help() {
    local string="$1"

#CZ#[ -n "$string" ] && string="\n$string"

    echo -e "\
Usage:
\t$this [ <file_name_1> <path_name_1> ] [ <file_name_2> <path_name_2> ] ... [ <file_name_N> <path_name_N> ]
$string"

    exit 1
}

################################################################################
case $cmmd_prog in
    cp ) cmmd_prog='cp -Rv' ; noty_prog='Copy' ;;
    mv ) cmmd_prog='mv -v'  ; noty_prog='Move' ;;
    *  ) echo "Comando '$this' non agganciato..." && exit 1
esac

################################################################################
[ $((${#*} % 2)) -ne 0 ] && _help "The parameters to be equal."

helpline=''
commands="\
xmppsend \"Init $noty_prog at \$(date)\" $notify_to"
#-------------------------------------------------------------------------------
while test -n "$1"; do
    file_name="$1" ; shift
    path_name="$1" ; shift
    path_file="$path_name/$file_name"

    [ ! -n "$file_name" ] && helpline="$helpline\nSpecifie File Name to copy."
    [ ! -n "$path_name" ] && helpline="$helpline\nSpecifie Path Name to destination copy."

    [ ! -r "$file_name" ] && helpline="$helpline\nFile Name '$file_name' can't be read."
    [ ! -d "$path_name" ] && helpline="$helpline\nPath Name '$path_name' can't be exist."

    [   -e "$path_file" ] && helpline="$helpline\nAttention: File Name '$file_name' already exist on '$path_name', skip!"

    xmppline="$noty_prog\n * $file_name\ninto\n * $path_name"
    xmpp_ok_="performed successfully :-)"
    xmpp_no_="isn't performed, error :-("
    commands="$commands
$cmmd_prog \"$file_name\" \"$path_name\" \
&& xmppsend \"$xmppline\n$xmpp_ok_\" $notify_to \
|| xmppsend \"$xmppline\n$xmpp_no_\" $notify_to \
"
done
#-------------------------------------------------------------------------------
commands="$commands
xmppsend \"Done $noty_prog at \$(date)\" $notify_to"

################################################################################
[ -n "$helpline" ] && _help "$helpline"

echo "$commands"

exit
