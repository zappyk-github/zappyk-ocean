#!/bin/env bash

pts_hh_mm_ss=$1
operation=$2
pte_hh_mm_ss=$3

help="Usage:
$(basename "$0") hh[:mm[:ss]] (+|-) hh[:mm[:ss]]
"

[ -z "$pts_hh_mm_ss" ] && echo "$help" && exit 1
[ -z "$operation"    ] && echo "$help" && exit 1
[ -z "$pte_hh_mm_ss" ] && echo "$help" && exit 1

_to2() {
    number=$1
    number=$(echo "$number*1" | bc)
    number=$(printf "%02d" "$number")
    echo "$number"
}

IFS=$':' read pts_hh pts_mm pts_ss < <(echo "$pts_hh_mm_ss")
IFS=$':' read pte_hh pte_mm pte_ss < <(echo "$pte_hh_mm_ss")

[ -z "$pts_ss" ] && pts_ss=0 ; pts_ss=$(_to2 "$pts_ss")
[ -z "$pts_mm" ] && pts_mm=0 ; pts_mm=$(_to2 "$pts_mm")
[ -z "$pts_hh" ] && pts_hh=0 ; pts_hh=$(_to2 "$pts_hh")
pts_hh_mm_ss="$pts_hh:$pts_mm:$pts_ss"

[ -z "$pte_ss" ] && pte_ss=0 ; pte_ss=$(_to2 "$pte_ss")
[ -z "$pte_mm" ] && pte_mm=0 ; pte_mm=$(_to2 "$pte_mm")
[ -z "$pte_hh" ] && pte_hh=0 ; pte_hh=$(_to2 "$pte_hh")
pte_hh_mm_ss="$pte_hh:$pte_mm:$pte_ss"

pts_sec=$(echo "((($pts_hh * 60) + $pts_mm) * 60) + $pts_ss" | bc)
pte_sec=$(echo "((($pte_hh * 60) + $pte_mm) * 60) + $pte_ss" | bc)

stp_sec=$(echo "$pts_sec $operation $pte_sec" | bc)
[ $stp_sec -lt 0 ] && stp_sec=$(echo "$stp_sec * -1" | bc) && neg='-' \
                                                           || neg='+'

stp_ss=$(echo "  $stp_sec % 60"             | bc)
stp_mm=$(echo " ($stp_sec / 60) % 60"       | bc)
stp_hh=$(echo "(($stp_sec / 60) / 60) % 60" | bc)

stp_ss=$(_to2 "$stp_ss")
stp_mm=$(_to2 "$stp_mm")
stp_hh=$(_to2 "$stp_hh")
stp_hh_mm_ss="$stp_hh:$stp_mm:$stp_ss"

printf " %1s%8s %1s  (%1s%8s sec. %1s)\n" ''   $pts_hh_mm_ss $operation ''   $pts_sec $operation
printf " %1s%8s %1s  (%1s%8s sec. %1s)\n" ''   $pte_hh_mm_ss ''         ''   $pte_sec ''
echo   "--------------(----------------)"
printf " %1s%8s %1s  (%1s%8s sec. %1s)\n" $neg $stp_hh_mm_ss ''         $neg $stp_sec ''
