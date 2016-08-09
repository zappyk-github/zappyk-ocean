#!/bin/env bash

operations='list'
repositories='
 100:fedora
  10:rawhide
 100:updates
  50:updates-testing

 100:rpmfusion-free
  10:rpmfusion-free-rawhide
 100:rpmfusion-free-updates
  50:rpmfusion-free-updates-testing

 100:rpmfusion-nonfree
  10:rpmfusion-nonfree-rawhide
 100:rpmfusion-nonfree-updates
  50:rpmfusion-nonfree-updates-testing

 100:playonlinux
 100:adobe-linux-i386
 100:lfarkas-truecrypt
 100:virtualbox
 100:Dropbox
#100:google
 100:google-chrome
 100:google-earth
 100:google-talkplugin
 100:google-musicmanager
 100:insync
 100:tech-3
#100:skype
 100:livna
 100:steam
'
search_packages='nvidia'
search_packages=''

directory="$HOME/Configurazioni/dnf"
mkdir -p "$directory"

dnf_cmd='dnf --quiet'
dnf_opt="$*"
dnf_exc='--disableexcludes=main'
dnf_rep='--disablerepo=* --enablerepo'
dnf_old=false

execute() {
    local cmd=$1
    local log=$2
    local exc=$3
    local str=$cmd

    [ -n "$log" ] && str="Create log $log ..." \
                  && cmd="$cmd > $log" \
                  && ( $dnf_old ) && mv -f $log $log.old 2>/dev/null

    echo "$str"
#CZ#echo "$cmd"
    eval "$cmd"
    eval "$exc"
}

execute_command() {
    local vie=$1
    local ope=$2
    local ite=$3
    local sep='+-->| Notify %-50s |--------------------------'
    local exe=''

    [ "${ite:0:1}" == '#' ] && return

    IFS=$':' read num rep < <(echo "$ite")
    [ -z "$rep" ] && rep=$num && num=50

               local log="$directory/dnf-$ope.log"
    [ -n "$rep" ] && log="$directory/dnf-$ope-$rep.log"
               local tag=$(printf "$sep" "$ope")
    [ -n "$rep" ] && tag=$(printf "$sep" "$ope repo: $rep")
               local cmd="$dnf_cmd $dnf_opt $ope"
#CZ#[ -n "$rep" ] && cmd="$dnf_cmd $dnf_opt $dnf_exc $dnf_rep=$rep $ope"
    [ -n "$rep" ] && cmd="$dnf_cmd $dnf_opt repo-pkgs $rep $ope"

    ( $vie ) && exc="[ -s "$log" ] && echo '$tag+' && cat '$log' | grep -v '^$' | tail -$num | sed 's/^/| /' && echo '+${tag//?/-}' && echo"

    execute "$cmd" "$log" "$exc"
}

execute_clean() {
    execute "$dnf_cmd clean all"
}

search() {
    local log=$1 ; shift
    local pkg=$* ; [ -z "$pkg" ] && return
    local str=`echo "$pkg" | sed 's/ / -e /'`

               local log="$directory/dnf*.log"
    [ -n "$ope" ] && log="$directory/dnf-$oper.log"

    echo "Searching $pkg in log $log ..."
    grep --colour -i -e $str $log
}

#CZ#execute_clean

for oper in $operations; do
    execute_command false "$oper"
#CZ#search "$directory/dnf-$oper.log" "$search_packages"
    search "$directory/dnf*.log" "$search_packages"

    for repo in $repositories; do
        execute_command false "$oper" "$repo"
    done

#CZ#execute_command false "$oper" "$repo"
done

exit
