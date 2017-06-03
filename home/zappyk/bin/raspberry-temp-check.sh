#!/bin/env bash

this=$(basename "$0" '.sh')
exit=0

_max_celsius="49.5"

save_measure=${1:-false}
path_measure="$HOME/log"
file_measure="$path_measure/$this.csv"
name_measure=$(uname -n)
date_measure=$(date +'%Y%m%d %H:%M.%S')

_value2int() {
    local celsius_temp=$1
    local value___temp=$(echo "$celsius_temp * 100" | bc)
    local valueinttemp=${value___temp%.*}
    echo "$valueinttemp"
}

measure_temp=$(vcgencmd measure_temp)
celsius_temp=$(echo "$measure_temp" | cut -d"=" -f2 | cut -d"'" -f1)

celsius_int_=$(_value2int "$celsius_temp")
_int_celsius=$(_value2int "$_max_celsius")

if ( $save_measure ); then
    mkdir -p "$path_measure"
    echo "$name_measure;$date_measure;$celsius_temp;$_max_celsius" >>"$file_measure"
else
    if [ $celsius_int_ -gt $_int_celsius ]; then
        echo "$HOSTNAME temp is $celsius_temp°C, alert! :-|"
        exit=1
    else
        echo "$HOSTNAME temp is $celsius_temp°C, normal :-D"
    fi
fi

exit $exit
