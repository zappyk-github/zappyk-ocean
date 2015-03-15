#!/bin/env bash

PATH_BATTERY='/proc/acpi/battery'

BATTERY_DENSIGN='design capacity:'
BATTERY_LASTFULL='last full capacity:'
BATTERY_REMAINING='remaining capacity:'

BATTERIES=$(cd "$PATH_BATTERY" && ls -d *)

################################################################################
_getValue() {
    local string=$1
    local file=$2

    grep "$string" $file | cut -d':' -f2 | sed 's/^ *//' | cut -d' ' -f1
}

################################################################################
_getValueDensign() {
    local battery=$1

    _getValue "$BATTERY_DENSIGN" "$PATH_BATTERY/$battery/info"
}

################################################################################
_getValueLastFull() {
    local battery=$1

    _getValue "$BATTERY_LASTFULL" "$PATH_BATTERY/$battery/info"
}

################################################################################
_getValueRemaining() {
    local battery=$1

    _getValue "$BATTERY_REMAINING" "$PATH_BATTERY/$battery/state"
}

################################################################################
_bc() {
    local string=$*

    echo "$string" | bc -l
}

################################################################################
_bc_scale() {
    local scale=$1
    local number=$2

    _bc "scale=$scale; $number / 1 * 1"
}

################################################################################
_write_echo() {
    local string=$1
    local length=$2

    printf "| %-${length}s |\n" "$string"
}

################################################################################
_write_line() {
    local string=$1

    printf "+-%s-+\n" "${string//?/-}"
}

################################################################################
_write_body() {
    local string=$1

    _write_line "$string"
    echo "| ${string} |"
}

for battery in $BATTERIES; do
    design=$(_getValueDensign $battery)
    lastfull=$(_getValueLastFull $battery)
    ramaining=$(_getValueRemaining $battery)

    declass=$(_bc "$lastfull / $design * 100")    ; declass=$(_bc_scale 2 "$declass")
    recharge=$(_bc "$ramaining / $lastfull * 100"); recharge=$(_bc_scale 2 "$recharge")
    deltacharge=$(_bc "$declass - 100")
    dummycharge=$(_bc "$recharge - $deltacharge")

    lmax=$battery
    log1=$(printf "%-18s = %6s"                 "Capacita' massima" "$design")                              ; [ ${#log1} -gt ${#lmax} ] && lmax=$log1
    log2=$(printf "%-18s = %6s = %6s%% (%6s%%)" "Capacita' attuale" "$lastfull"  "$declass"  "$deltacharge"); [ ${#log2} -gt ${#lmax} ] && lmax=$log2
    log3=$(printf "%-18s = %6s = %6s%% (%6s%%)" "Ricarica  attuale" "$ramaining" "$recharge" "$dummycharge"); [ ${#log3} -gt ${#lmax} ] && lmax=$log3

    _write_body "$battery"
    _write_line "$lmax"
    _write_echo "$log1" "${#lmax}"
    _write_echo "$log2" "${#lmax}"
    _write_echo "$log3" "${#lmax}"
    _write_line "$lmax"
done

exit
