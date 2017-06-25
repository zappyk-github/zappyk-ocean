#!/usr/bin/env bash

this=$(basename "$0" '.sh')
copy=${1:-true}

dir_copy=${2:-.}
csv_seps=";"
csv_head="HOST${csv_seps}TEMP_LIMIT${csv_seps}DATE_TIME${csv_seps}TEMP"

hostcopy='1 2'
hosttvpn='- t1 t2'
user_tag='zappyk'
host_tag='zappyk-rp%s'
file_tag='log/raspi%s-raspberry-temp-check.csv'
last_row=15000

################################################################################
_cat() {
    local file=$1
    if [ $last_row -eq 0 ]; then
        cat "$file"
    else
        tail -n $last_row "$file"
    fi
}

for i in $hostcopy; do
    host=$(printf "$host_tag" "$i")
    file=$(printf "$file_tag" "$i")
    name=$(basename "$file")
    csvI="$dir_copy/$name"
    csvO="$dir_copy/$name.csv"

    [ $i -eq 1 ] && orig1csv=$csvI && file1csv=$csvO
    [ $i -eq 2 ] && orig2csv=$csvI && file2csv=$csvO

    sync=$copy ; [ ! -e "$csvO" ] && sync=true

    if ( $sync ); then
        scp=false
        for t in $hosttvpn; do
            [ "$t" == '-' ] && t=''
            rip=$(printf "$host_tag$t" "$i")
            ping $rip -c 3 >/dev/null
            if [ $? -eq 0 ]; then
                echo "Copy  \"$rip:$file\"  in  \"$dir_copy\"  ..."
                scp $user_tag@$rip:"$file" "$dir_copy"
                scp=true
                break
            fi
        done
        if ( $scp ); then
            echo "$csv_head" >"$csvO"
            _cat  "$csvI"   >>"$csvO"
        else
            echo "Not copy from $host file $file, peervpn not close!"
        fi
    fi
done
file1tag=$(cat "$file1csv" | cut -d"$csv_seps" -f1 | tail -n -2 | sort -u)
file2tag=$(cat "$file2csv" | cut -d"$csv_seps" -f1 | tail -n -2 | sort -u)
exte_out="png"
file_out="$dir_copy/$this.$exte_out"

exit_code=0
gnuplot << EOR && echo "View graphic file $file_out :-D"  || { exit_code=$?; echo "Graphic file not crete! :-|"; }
#set terminal $exte_out 
 set terminal $exte_out size 2048,1024
 set output "$file_out"

 set xdata  time
 set x2data time
 set timefmt '%Y%m%d %H:%M'
 set xlabel "DATE_TIME"
 set ylabel "TEMP"
 set title  "Raspberry Pi (on $HOSTNAME)"

 set datafile separator "$csv_seps"
 set key autotitle columnhead
 set key outside right center
 set style data linespoints
#set autoscale fix

#set yrange [0:10]
#set xrange [0:10]
 set grid ytics mytics # draw lines for each ytics and mytics
 set grid xtics mxtics # draw lines for each ytics and mytics
 set mytics  5         # set the spacing for the mytics
 set mxtics 20         # set the spacing for the mxtics
 set grid              # enable the grid
#set ytic 2.5

 set ytics nomirror
 set y2tics
 set xtics nomirror
 set x2tics

#set style line 100 lt 1 lc rgb "gray" lw 2
#set style line 101 lt 1 lc rgb "gray" lw 1
#set grid xtics  ytics  ls 100
#set grid mxtics mytics ls 101


#set size square 5,5
#set size ratio 0.5
 set size 1,1

#plot "$file1csv" using 3:4 with lines
#plot "$file1csv" using 3:4 with linespoints pointtype 3 title ""
#plot "$file1csv" using 3:4 with lines title "" lt -1 lw 2
#plot "$file1csv" using 3:4 with lines title "$file1tag", "$file2csv" using 3:4 with lines title "$file2tag"
 plot "$file1csv" using 3:4 with lines title "$file1tag", "$file2csv" using 3:4 with lines title "$file2tag"
EOR

 rm -f "$orig1csv" "$orig2csv"
#rm -f "$file1csv" "$file2csv"

exit $exit_code
