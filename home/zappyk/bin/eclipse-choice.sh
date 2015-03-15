#!/bin/env bash

eclipse_type='ganymede'
eclipse_type='galileo'

eclipse_name='eclipse'
eclipse_exec="$eclipse_name.sh"
eclipse_path="$eclipse_name-choice"
eclipse_base="$JAVA_PLUS/$eclipse_name"
eclipse_save='eclipse_save'
eclipse_list=''

zenity_text="Eclipse IDE ($eclipse_type) chose:"
zenity_cmmd="zenity  --list  --text '$zenity_text' --radiolist --column 'select' --column 'description'"

sep1='-'
sep2=':'

_choseList() {
    local id_de=$1

    case "$id_de" in
        'cpp'       ) echo 'C/C++ Developers'           ;;
        'java'      ) echo 'Java Developers'            ;;
        'jee'       ) echo 'Java EE Developers'         ;;
        'modeling'  ) echo 'Modeling Tools'             ;;
        'rcp'       ) echo 'RCP/Plug-in Developers'     ;;
        'reporting' ) echo 'Java and Report Developers' ;;
        'SDK'       ) echo 'Classic'                    ;;
    esac

    case "$id_de" in
        'C/C++ Developers'           ) echo 'cpp'       ;;
        'Java Developers'            ) echo 'java'      ;;
        'Java EE Developers'         ) echo 'jee'       ;;
        'Modeling Tools'             ) echo 'modeling'  ;;
        'RCP/Plug-in Developers'     ) echo 'rcp'       ;;
        'Java and Report Developers' ) echo 'reporting' ;;
        'Classic'                    ) echo 'SDK'       ;;
    esac
}

_getList() {
    for list in $eclipse_list; do
        IFS=$sep2 read id dir < <(echo "$list")

        flag='FALSE'
        [ "$eclipse_link" == "$dir" ] && flag='TRUE'

        de=$(_choseList "$id")
        [ -n "$de" ] && echo -n " $flag '$de' "
    done
}

_init() {
    cd $eclipse_base || exit 1

    for dir in $(ls -d $eclipse_name$sep*$eclipse_type*); do
        [ ! -d "$dir" ] && continue

        IFS=$sep1 read uuid id name < <(echo "$dir")

        eclipse_list="$eclipse_list $id$sep2$dir"

        variable="${eclipse_save}_$id" && eval $variable=$dir
    done
}

_main() {
    eclipse_link=`readlink "$eclipse_path"`

    zenity_list=`_getList`
    zenity_cmmd="$zenity_cmmd $zenity_list"

    name_de=$(eval "$zenity_cmmd")
    name_id=$(_choseList "$name_de")

    variable="${eclipse_save}_$name_id"
    path_id=$(echo ${!variable})

    [ -n "$path_id" ] && rm -f "$eclipse_path" && ln -fs "$path_id" "$eclipse_path" && eval "$eclipse_exec"
}

_init

_main

exit
