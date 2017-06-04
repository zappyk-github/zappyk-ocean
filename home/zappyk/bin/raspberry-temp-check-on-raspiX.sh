#!/usr/bin/env bash

this=$(basename "$0" '.sh')
copy=${1:-true}

dir_copy=${2:-.}
csv_seps=";"
csv_head="HOST${csv_seps}TEMP_LIMIT${csv_seps}DATE_TIME${csv_seps}TEMP"

hostcopy='1 2'
user_tag='zappyk'
host_tag='zappyk-rp%s'
file_tag='log/raspi%s-raspberry-temp-check.csv'
for i in $hostcopy; do
    host=$(printf "$host_tag" "$i")
    file=$(printf "$file_tag" "$i")
    name=$(basename "$file")
    csvI="$dir_copy/$name"
    csvO="$dir_copy/$name.csv"

    [ $i -eq 1 ] && csv1=$csvI && file1csv=$csvO
    [ $i -eq 2 ] && csv2=$csvI && file2csv=$csvO

    sync=$copy ; [ ! -e "$csvO" ] && sync=true

    if ( $sync ); then
        echo "Copy  \"$host:$file\"  in  \"$dir_copy\"  ..."
        scp $user_tag@$host:"$file" "$dir_copy"
        echo "$csv_head" >"$csvO"
        cat  "$csvI"    >>"$csvO"
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

 set xdata time
 set timefmt '%Y%m%d %H:%M'
 set xlabel "DATE_TIME"
 set ylabel "TEMP"
 set title  "Raspberry Pi"

 set key outside right center
 set style data linespoints
#set autoscale fix

#set yrange [0:10]
#set xrange [0:10]
 set grid ytics mytics  # draw lines for each ytics and mytics
 set grid xtics mxtics  # draw lines for each ytics and mytics
 set mytics  5          # set the spacing for the mytics
 set mxtics 20          # set the spacing for the mxtics
 set grid               # enable the grid
#set ytic 2.5

#set style line 100 lt 1 lc rgb "gray" lw 2
#set style line 101 lt 1 lc rgb "gray" lw 1
#set grid xtics  ytics  ls 100
#set grid mxtics mytics ls 101


#set size square 5,5
#set size ratio 0.5
 set size 1,1

 set datafile separator "$csv_seps"
#plot "$file1csv" using 3:4 with lines
#plot "$file1csv" using 3:4 with linespoints pointtype 3 title ""
#plot "$file1csv" using 3:4 with lines title "" lt -1 lw 2
#plot "$file1csv" using 3:4 with lines title "$file1tag", "$file2csv" using 3:4 with lines title "$file2tag"
 plot "$file1csv" using 3:4 with lines title "$file1tag", "$file2csv" using 3:4 with lines title "$file2tag"
EOR

 rm -fv "$csv1"     "$csv2"
 rm -fv "$file1csv" "$file2csv"

exit $exit_code
