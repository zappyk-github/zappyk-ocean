#!/bin/env bash

_gconf_all_entries() {
    local string=$1
    gconftool-2 --all-entries "$string"
}

_gconf_all_dirs() {
    local string=$1
    gconftool-2 --all-dirs "$string"
}

_recursive_gconf_all_dirs() {
    local string=$1
    for dir in $(_gconf_all_dirs "$string"); do
        echo "|# |$dir"
        local value=$(_gconf_all_dirs "$dir")
        if [ -n "$value" ]; then
            _recursive_gconf_all_dirs "$dir"
        else
            _gconf_all_entries "$string" | sed 's/^/| *|/g'
        fi
    done
}

_recursive_dconf_show() {
    for SCHEMA in $(gsettings list-schemas | sort); do
        echo '--------------------------------------------------------------------------------'
       #gsettings list-recursively "$SCHEMA"
        for KEY    in $(gsettings list-keys $SCHEMA | sort); do
            VAL=$(gsettings get "$SCHEMA" "$KEY")
            printf "%-50s %-50s=%s\n" "$SCHEMA" "($KEY)" "[$VAL]"
        done
    done
}

_recursive_dconf_show

read -p "Premere CTRL-C per fermare l'esecuzione... " -t 3
echo
_recursive_gconf_all_dirs '/'
echo '________________________________________________________________________'
echo 'http://library.gnome.org/admin/system-admin-guide/stable/gconf-6.html.it'

exit
