#!/bin/env bash
#
# usage: pdf2booklet file.pdf
#
file_in=$1
filebase=`basename "$file_in" .pdf`
file_out=`dirname "$file_in"`/$filebase-booklet.pdf

number_pid=`printf "%05d" $$`
number_random=`printf "%05d" $RANDOM`

file_temp1="/tmp/tmp-$USER-$number_pid-$number_random.$filebase.1.pdf"
file_temp2="/tmp/tmp-$USER-$number_pid-$number_random.$filebase.2.pdf"
file_empty="/tmp/tmp-$USER-$number_pid-$number_random.page-empty.pdf"

read_page_number=false
page_number_multiple=4

echo -n "Ricerca dei programmi necessari... "
find=`which pdftk   2>/dev/null` ; [ -z "$find" ] && read_page_number=true
find=`which pdfjoin 2>/dev/null` ; [ -z "$find" ] && { echo "ATTENZIONE, non trovo il programma pdfjoin!"; exit 1; }
find=`which pdfnup  2>/dev/null` ; [ -z "$find" ] && { echo "ATTENZIONE, non trovo il programma pdfnup!" ; exit 1; }
find=`which a2ps    2>/dev/null` ; [ -z "$find" ] && { echo "ATTENZIONE, non trovo il programma a2ps!"   ; exit 1; }
find=`which ps2pdf  2>/dev/null` ; [ -z "$find" ] && { echo "ATTENZIONE, non trovo il programma ps2pdf!" ; exit 1; }
find=`which cp      2>/dev/null` ; [ -z "$find" ] && { echo "ATTENZIONE, non trovo il programma cp!"     ; exit 1; }
find=`which rm      2>/dev/null` ; [ -z "$find" ] && { echo "ATTENZIONE, non trovo il programma rm!"     ; exit 1; }
echo "ok"

basename=`basename "$0"`
[ -z "$file_in" ] && echo -e "Usage:\n\t\t$basename <file.pdf>" && exit

echo -n "Trasformazione pdf in formato A4... "
\pdfjoin "$file_in" --outfile "$file_temp1" --paper a4paper --fitpaper false >/dev/null \
&& echo "ok" \
|| { echo "ATTENZIONE, il file non e' stato trasformato!"; exit 1; }

if ($read_page_number); then
echo -n "Inserire il numero di pagine del file '$file_in': "
read page_number
else
echo -n "Conteggio automatico numero di pagine... "
read page_number < <(\pdftk "$file_temp1" dump_data | grep 'NumberOfPages:' | cut -d':' -f2)
echo "$page_number"
fi

echo -n "Calcolo delle pagine bianche da inserire alla fine... "
page_empty_number=$(($page_number_multiple - $page_number % $page_number_multiple));
[ $page_empty_number -eq $page_number_multiple ] && page_empty_number=0
echo "$page_empty_number"

page_number=$(($page_number + $page_empty_number))

if [ $page_empty_number -ne 0 ]; then
    echo -n "Aggiunta di pagine vuote al documento... "
    echo '' | \a2ps --medium=A4 --columns=1 --borders=no --no-header --quiet - -o - | \ps2pdf -sPAPERSIZE=a4 - "$file_empty"
    while [ $page_empty_number -ne 0 ]; do
        echo -n "$page_empty_number "
    #CZ#\pdftk "$file_temp1" "$file_empty" cat output "$file_temp2" && \cp -f "$file_temp2" "$file_temp1"
        \pdfjoin "$file_temp1" "$file_empty" --fitpaper false --paper a4paper --outfile "$file_temp2" && \cp -f "$file_temp2" "$file_temp1"
        page_empty_number=$(($page_empty_number - 1))
    done
    echo "ok"
else
    \cp -f "$file_temp1" "$file_temp2"
fi

echo -n "Determinazione elenco delle pagine... "
page_sx=$(($page_number / 2))
page_dx=$(($page_sx + 1))
page_list="$page_sx,$page_dx";
while [ $page_sx -ne 1 ]; do
    page_sx=$(($page_sx - 1))
    page_dx=$(($page_dx + 1))
    page_list="$page_list,$page_dx,$page_sx";
    if [ $page_sx -ne 1 ]; then
        page_sx=$(($page_sx - 1))
        page_dx=$(($page_dx + 1))
        page_list="$page_list,$page_sx,$page_dx";
    fi
done
echo "$page_list"

echo -n "Impaginazione del documento... "
#CZ#pdfnup --nup 1x2 --orient portrait --frame true --delta "2cm 2cm" --offset "0.5cm 0.5cm" --paper a4paper --scale 0.8 --outfile "$file_out" "$file_temp2"
\pdfnup --nup 2x1 --pages "$page_list" --paper a4paper --outfile "$file_out" "$file_temp2" >/dev/null \
&& echo "$file_out creato" \
|| echo "ATTENZIONE, file booklet non creato!"

echo -n "Rimozione file superflui... "
\rm -f "$file_temp1"
\rm -f "$file_temp2"
\rm -f "$file_empty"
echo "ok"

exit
