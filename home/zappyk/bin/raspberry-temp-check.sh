#!/bin/env bash

_max_celsius="50.4"

_value2int() {
    local celsius_temp=$1
    local value___temp=$(echo "$celsius_temp * 100" | bc)
    local valueinttemp=${value___temp%.*}
    echo "$valueinttemp"
}

#measure_temp=$(vcgencmd measure_temp)
measure_temp="temp=50.3'C"
celsius_temp=$(echo "$measure_temp" | cut -d"=" -f2 | cut -d"'" -f1)

celsius_int_=$(_value2int "$celsius_temp")
_int_celsius=$(_value2int "$_max_celsius")

echo "[$celsius_int_] > [$_int_celsius] ?"
if [ $celsius_int_ -gt $_int_celsius ]; then
    echo "YES"
else
    echo "No!"
fi

exit
